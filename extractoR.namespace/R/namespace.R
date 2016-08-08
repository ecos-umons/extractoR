ReadCRANNamespace <- function(package, version, datadir) {
  loginfo("Parsing CRAN NAMESPACE file from %s %s",
          package, version, logger="namespace.cran")
  tryCatch({
    parseNamespaceFile(package, file.path(datadir, package, version))
  }, error=function(e) NULL)
}

ReadGithubNamespace <- function(package, ref, datadir) {
  loginfo("Parsing Github NAMESPACE file from package %s %s",
          package, ref, logger="namespace.github")
  repo.name <- ParseGithubRepositoryName(package)
  RunGit(function() {
    filename <- file.path(repo.name$subdir, "NAMESPACE")
    status <- system2("git", c("checkout", ref, filename))
    if (!status) {
      res <- tryCatch({
        parseNamespaceFile(basename(normalizePath(repo.name$subdir)),
                           file.path(repo.name$subdir, ".."))
      }, error=function(e) NULL)
      system2("git", c("checkout", "HEAD", filename))
      res
    }
  }, file.path(datadir, repo.name$owner, repo.name$repository))
}

ReadNamespace <- function(source, repository, version, datadir) {
  dir <- file.path(datadir, source)
  if (source == "cran") {
    ReadCRANNamespace(repository, version, file.path(dir, "packages"))
  } else if (source == "github") {
    ReadGithubNamespace(repository, version, file.path(dir, "repos"))
  } else {
    stop(sprintf("Unknown source: %s", source))
  }
}

Namespaces <- function(index, datadir) {
  res <- mapply(ReadNamespace, index$source, index$repository, index$ref,
                MoreArgs=list(datadir), SIMPLIFY=FALSE)
  names(res) <- paste(index$source, index$repository, index$ref, sep=":")
  res[!sapply(res, is.null)]
}
