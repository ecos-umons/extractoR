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

Namespaces <- function(index, datadir) {
  res <- mapply(function(src, repository, version) {
    dir <- file.path(datadir, src)
    if (src == "cran") {
      ReadCRANNamespace(repository, version, file.path(dir, "packages"))
    } else if (src == "github") {
      ReadGithubNamespace(repository, version, file.path(dir, "repos"))
    } else {
      stop(sprintf("Unknown source: %s", src))
    }
  }, index$source, index$repository, index$ref, SIMPLIFY=FALSE)
  names(res) <- file.path(index$source, index$repository, index$ref)
  res[!sapply(res, is.null)]
}
