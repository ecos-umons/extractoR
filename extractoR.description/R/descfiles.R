GuessEncoding <- function(filename) {
  # Guesses the encoding of a file.
  cmd <- sprintf("file --mime-encoding %s", filename)
  strsplit(system(cmd, intern=TRUE), " ")[[1]][2]
}

ReadDescfile <- function(filename) {
  descfile <- read.dcf(filename)
  values <- as.vector(descfile[1, ])
  encoding <- "utf8"
  if (inherits(filename, "character")){
    encoding <- GuessEncoding(filename)
  }
  if ("Encoding" %in% colnames(descfile)) {
    encoding <- descfile[colnames(descfile) == "Encoding"]
  }
  if (!tolower(encoding) %in% c("utf8", "utf-8", "cannot")) {
    values <- iconv(as.vector(descfile[1, ]), encoding, "utf8")
  }
  as.data.table(list(key=colnames(descfile), value=values))
}

ReadCRANDescfile <- function(package, version, datadir) {
  loginfo("Parsing CRAN DESCRIPTION file from %s %s",
          package, version, logger="description.cran")
  ReadDescfile(file.path(datadir, package, version, package, "DESCRIPTION"))
}

ReadGithubDescfile <- function(repository, ref, datadir) {
  loginfo("Parsing Github DESCRIPTION file from %s %s",
          repository, ref, logger="description.github")
  repo.name <- ParseGithubRepositoryName(repository)
  RunGit(function() {
    filename <- file.path(repo.name$subdir, "DESCRIPTION")
    f <- system2("git", c("ls-tree", ref, filename), stdout=TRUE)
    if (length(f)) {
      args <- c("cat-file", "-p", strsplit(f, " |\t")[[1]][3])
      ReadDescfile(textConnection(system2("git", args, stdout=TRUE)))
    }
  }, file.path(datadir, repo.name$owner, repo.name$repository))
}

Descfiles <- function(index, datadir) {
  res <- rbindlist(mapply(function(src, repository, version) {
    dir <- file.path(datadir, src)
    if (src == "cran") {
      res <- ReadCRANDescfile(repository, version, file.path(dir, "packages"))
    } else if (src == "github") {
      res <- ReadGithubDescfile(repository, version, file.path(dir, "repos"))
    } else {
      stop(sprintf("Unknown source: %s", src))
    }
    if (!is.null(res) && nrow(res)) {
      cbind(data.table(source=src, repository, version), res)
    }
  }, index$source, index$repository, index$ref, SIMPLIFY=FALSE))
  re <- "^\\s*(\\d+([-.]\\d+)*\\S*)(\\s.*)?$"
  res[key == "Version", value := sub(re, "\\1", value)]
  res
}
