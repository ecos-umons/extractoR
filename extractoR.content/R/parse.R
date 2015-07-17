ParseCRANPackage <- function(package, version, datadir) {
  loginfo("Parsing R code from CRAN package %s %s",
          package, version, logger="code.cran")
  filename <- file.path(datadir, package, version, package)
  tryCatch(sourceR::ParsePackage(filename), error=identity)
}

ParseGithubPackage <- function(package, ref, datadir) {
  loginfo("Parsing R code from Github package %s %s",
          package, ref, logger="code.github")
  repo.name <- ParseGithubRepositoryName(package)
  RunGit(function() {
    filename <- file.path(repo.name$subdir, "R")
    status <- system2("git", c("checkout", ref, filename))
    if (!status) {
      res <- tryCatch(sourceR::ParsePackage(dirname(filename)), error=identity)
      system2("git", c("checkout", "HEAD", filename))
      res
    }
  }, file.path(datadir, repo.name$owner, repo.name$repository))
}

ParsePackage <- function(source, repository, ref, datadir) {
  dir <- file.path(datadir, source)
  if (source == "cran") {
    res <- ParseCRANPackage(repository, ref, file.path(dir, "packages"))
  } else if (source == "github") {
    res <- ParseGithubPackage(repository, ref, file.path(dir, "repos"))
  } else {
    stop(sprintf("Unknown source: %s", src))
  }
  data <- list(source=source, repository=repository, ref=ref)
  if (is.list(res)) {
    data$code <- res
  } else if (inherits(res, "error")) {
    data$err <- res
  } else if (!is.null(res)) {
    stop("Unknown result")
  }
  data
}
