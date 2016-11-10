ParseCode <- function(datadir, db="rdata", host="mongodb://localhost") {
  index <- as.data.table(mongo("index", db, host)$find())
  filenames <- index[, file.path(datadir, "code", source, repository,
                                 sprintf("%s.rds", ref))]
  index <- index[!file.exists(filenames)]

  message("Parsing package code")
  t <- system.time({
    with(index, mapply(function(src, repo, ref) {
      dest <- file.path(datadir, "code", src, repo, sprintf("%s.rds", ref))
      if (!file.exists(dest)) {
        dir.create(dirname(dest), recursive=TRUE)
        saveRDS(extractoR.content::ParsePackage(src, repo, ref, datadir), dest)
      }
    }, source, repository, ref))
  })
  message(sprintf("Package code parsed in %.3fs", t[3]))
}

ExtractFunctions <- function(datadir, db="rdata", host="mongodb://localhost", cluster.size=6) {
  index <- as.data.table(mongo("index", db, host)$find())
  src <- index[, file.path(datadir, "code", source, repository,
                           sprintf("%s.rds", ref))]
  dest <- index[, file.path(datadir, "functions", source, repository,
                            sprintf("%s.rds", ref))]
  index <- index[file.exists(src) & !file.exists(dest)]
  if (nrow(index) == 0) return(invisible(NULL))

  message("Extracting functions")
  cl <- InitCluster("code.functions", "code.log", n=cluster.size)
  t <- system.time({
    res <- with(index, clusterMap(cl, function(src, repo, ref) {
      dest <- file.path(datadir, "functions", src, repo, sprintf("%s.rds", ref))
      src <- file.path(datadir, "code", src, repo, sprintf("%s.rds", ref))
      code <- readRDS(src)
      if (is.null(code$err)) {
        res <- try(extractoR.content::FunctionDefinitions(code))
        if (!inherits(res, "try-error")) {
          dir.create(dirname(dest), recursive=TRUE, showWarnings=FALSE)
          try(saveRDS(res, dest))
          return(TRUE)
        }
      }
      return(FALSE)
    }, source, repository, ref))
  })
  message(sprintf("Functions extracted in %.3fs", t[3]))
  stopCluster(cl)
  invisible(res)
}

ExtractFunctionCalls <- function(datadir, db="rdata", host="mongodb://localhost", cluster.size=6) {
  index <- as.data.table(mongo("index", db, host)$find())
  src <- index[, file.path(datadir, "code", source, repository,
                           sprintf("%s.rds", ref))]
  dest <- index[, file.path(datadir, "calls", source, repository,
                            sprintf("%s.rds", ref))]
  index <- index[file.exists(src) & !file.exists(dest)]
  if (nrow(index) == 0) return(invisible(NULL))

  message("Extracting function calls")
  cl <- InitCluster("code.calls", "code.log", n=cluster.size)
  t <- system.time({
    res <- with(index, clusterMap(cl, function(src, repo, ref) {
      dest <- file.path(datadir, "calls", src, repo, sprintf("%s.rds", ref))
      src <- file.path(datadir, "code", src, repo, sprintf("%s.rds", ref))
      code <- readRDS(src)
      if (is.null(code$err)) {
        res <- try(extractoR.content::FunctionCalls(code))
        if (!inherits(res, "try-error")) {
          dir.create(dirname(dest), recursive=TRUE, showWarnings=FALSE)
          saveRDS(res, dest)
          return(TRUE)
        }
      }
      return(FALSE)
    }, source, repository, ref))
  })
  message(sprintf("Function calls extracted in %.3fs", t[3]))
  stopCluster(cl)
  invisible(res)
}

ExtractCodingStyle <- function(datadir, db="rdata", host="mongodb://localhost", cluster.size=6) {
  index <- as.data.table(mongo("index", db, host)$find())
  src <- index[, file.path(datadir, "code", source, repository,
                           sprintf("%s.rds", ref))]
  dest <- index[, file.path(datadir, "codingstyle", source, repository,
                            sprintf("%s.rds", ref))]
  index <- index[file.exists(src) & !file.exists(dest)]
  if (nrow(index) == 0) return(invisible(NULL))

  message("Extracting coding style")
  cl <- InitCluster("code.codingstyle", "code.log", n=cluster.size)
  t <- system.time({
    res <- with(index, clusterMap(cl, function(src, repo, ref) {
      dest <- file.path(datadir, "codingstyle", src, repo, sprintf("%s.rds", ref))
      src <- file.path(datadir, "code", src, repo, sprintf("%s.rds", ref))
      code <- readRDS(src)
      if (is.null(code$err)) {
        res <- try(extractoR.content::CodingStyle(code))
        if (!inherits(res, "try-error")) {
          dir.create(dirname(dest), recursive=TRUE, showWarnings=FALSE)
          saveRDS(res, dest)
          return(TRUE)
        }
      }
      return(FALSE)
    }, source, repository, ref))
  })
  message(sprintf("Coding style extracted in %.3fs", t[3]))
  stopCluster(cl)
  invisible(res)
}

ResolveFunctionCalls <- function(datadir) {
  packages <- readRDS(file.path(datadir, "rds", "packages.rds"))
  exports <- readRDS(file.path(datadir, "rds", "exports_expanded.rds"))
  exports <- merge(exports, packages, by=c("source", "repository", "ref"))
  deps <- readRDS(file.path(datadir, "rds", "deps.rds"))
  deps <- deps[type.name %in% c("imports", "depends", "linkingto")]
  setkey(deps, source, repository, ref, dependency)

  src1 <- packages[, file.path(datadir, "functions", source, repository,
                               sprintf("%s.rds", ref))]
  src2 <- packages[, file.path(datadir, "calls", source, repository,
                               sprintf("%s.rds", ref))]
  dest1 <- packages[, file.path(datadir, "calls-implicit", source, repository,
                                sprintf("%s.rds", ref))]
  dest2 <- packages[, file.path(datadir, "calls-explicit", source, repository,
                                sprintf("%s.rds", ref))]
  packages <- packages[file.exists(src1) & file.exists(src2) &
                       !file.exists(dest1) & !file.exists(dest2)]
  if (nrow(packages) == 0) return(invisible(NULL))

  message("Resolving function calls")
  t <- system.time({
    mapply(function(src, repo, ref) {
      dest <- file.path(datadir, "calls-explicit", src, repo,
                        sprintf("%s.rds", ref))
      dir.create(dirname(dest), recursive=TRUE)
      res <- extractoR.content::ExplicitCalls(src, repo, ref, datadir)
      saveRDS(res, dest)

      dest <- file.path(datadir, "calls-implicit", src, repo,
                        sprintf("%s.rds", ref))
      dir.create(dirname(dest), recursive=TRUE)
      deps.exports <- exports[package %in% deps[list(src, repo, ref),
                                                unique(dependency)]]
      res <- extractoR.content::ImplicitCalls(src, repo, ref, datadir,
                                              deps.exports)
      saveRDS(res, dest)
    }, packages$source, packages$repository, packages$ref)
  })
  message(sprintf("Function calls resolved in %.3fs", t[3]))
}
