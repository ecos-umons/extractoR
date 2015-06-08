GuessEncoding <- function(filename) {
  # Guesses the encoding of a file.
  cmd <- sprintf("file --mime-encoding %s", filename)
  strsplit(system(cmd, intern=TRUE), " ")[[1]][2]
}

ReadDescfile <- function(filename, package=NA, version=NA) {
  if (file.exists(filename)) {
    descfile <- read.dcf(filename)
    values <- as.vector(descfile[1, ])
    encoding <- GuessEncoding(filename)
    if ("Encoding" %in% colnames(descfile)) {
      encoding <- descfile[colnames(descfile) == "Encoding"]
    }
    values <- iconv(as.vector(descfile[1, ]), encoding, "utf8")
    n <- ncol(descfile)
    res <- as.data.table(list(key=colnames(descfile), value=values))
    if (is.na(package) | is.na(version)) res
    else cbind(data.table(package=package, version=version), res)
  }
}

ReadCRANDescfile <- function(package, version, datadir) {
  loginfo("Parsing CRAN DESCRIPTION file from %s %s",
          package, version, logger="extract.descfile.cran")
  filename <- file.path(datadir, package, version, package, "DESCRIPTION")
  descfile <- ReadDescfile(filename, package, version)
  if (!is.null(descfile)) cbind(data.table(source="cran"), descfile)
}

ReadGithubDescfile <- function(package, ref, datadir) {
  loginfo("Parsing Github DESCRIPTION file from package %s %s",
          package, ref, logger="extract.descfile.github")
  repo.name <- ParseGithubRepositoryName(package)
  RunGit(function() {
    filename <- file.path(repo.name$subdir, "DESCRIPTION")
    status <- system2("git", c("checkout", ref, filename))
    if (!status) {
      res <- tryCatch(ReadDescfile(filename), error=function(e) NULL)
      system2("git", c("checkout", "HEAD", filename))
      if (!is.null(res)) {
        cbind(data.table(source="cran", package, version=ref), res)
      }
    }
  }, file.path(datadir, repo.name$owner, repo.name$repository))
}

Descfiles <- function(index, datadir) {
  rbindlist(mapply(function(src, repository, version) {
    dir <- file.path(datadir, src)
    if (src == "cran") {
      ReadCRANDescfile(repository, version, file.path(dir, "packages"))
    } else if (src == "github") {
      ReadGithubDescfile(repository, version, file.path(dir, "repos"))
    } else {
      stop(sprintf("Unknown source: %s", src))
    }
  }, index$source, index$repository, index$version, SIMPLIFY=FALSE))
}

IsPackage <- function(descfile) {
  descfile[, "Package" %in% key && "Version" %in% key]
}

IsBroken <- function(descfile) {
  !IsPackage(descfile) || !DepsWellFormatted(descfile)
}

BrokenPackages <- function(descfiles) {
  res <- descfiles[, list(is.package=IsPackage(.SD),
                          deps.well.formatted=DepsWellFormatted(.SD)),
                   by=c("package", "version")]
  res[, is.broken := !is.package | !deps.well.formatted]
}
