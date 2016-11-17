ReadCRANNamespace <- function(package, version, datadir) {
  loginfo("Parsing CRAN NAMESPACE file from %s %s",
          package, version, logger="namespace.cran")
  tryCatch({
    parseNamespaceFile(package, file.path(datadir, package, version))
  }, error=function(e) NULL)
}

ReadGithubNamespace <- function(repository, ref, datadir) {
  loginfo("Parsing Github NAMESPACE file repository %s %s",
          repository, ref, logger="namespace.github")
  repo.name <- ParseGithubRepositoryName(repository)
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
  rbindlist(mapply(function(source, repository, ref) {
    dir <- file.path(datadir, source)
    if (source == "cran") {
      res <- ReadCRANNamespace(repository, ref, file.path(dir, "packages"))
    } else if (source == "github") {
      res <- ReadGithubNamespace(repository, ref, file.path(dir, "repos"))
    } else {
      stop(sprintf("Unknown source: %s", source))
    }
    res$nativeRoutines <- lapply(res$nativeRoutines, function(nr) {
      if (inherits(nr, "NativeRoutineMap")) {
        class(nr) <- "list"
        nr
      }
    })
    if (length(res)) {
      data.table(source, repository, ref, namespace=list(res))
    }
  }, index$source, index$repository, index$ref, SIMPLIFY=FALSE))
}

ExtractNamespaceFiles <- function(datadir, db="rdata", host="mongodb://localhost") {
  index <- mongo("index", db, host)$find()

  con <- mongo("namespace", db, host)
  message("Reading namespace files")
  t <- system.time({
    namespace <- Namespaces(MissingEntries(index, con), datadir)
  })
  message(sprintf("Namespace files read in %.3fs", t[3]))
  con$insert(namespace)
}
