ParseCode <- function(datadir) {
  packages <- readRDS(file.path(datadir, "rds", "packages.rds"))
  filenames <- packages[, file.path(datadir, "code", source, repository,
                                    sprintf("%s.rds", ref))]
  packages <- packages[!file.exists(filenames)]

  message("Parsing package code")
  t <- system.time({
    mapply(function(src, repo, ref) {
      dest <- file.path(datadir, "code", src, repo, sprintf("%s.rds", ref))
      if (!file.exists(dest)) {
        dir.create(dirname(dest), recursive=TRUE)
        saveRDS(extractoR.content::ParsePackage(src, repo, ref, datadir), dest)
      }
    }, packages$source, packages$repository, packages$ref)
  })
  message(sprintf("Package code parsed in %.3fs", t[3]))
}

ExtractFunctions <- function(datadir, cluster.size=6) {
  packages <- readRDS(file.path(datadir, "rds", "packages.rds"))
  src <- packages[, file.path(datadir, "code", source, repository,
                              sprintf("%s.rds", ref))]
  dest <- packages[, file.path(datadir, "functions", source, repository,
                               sprintf("%s.rds", ref))]
  packages <- packages[file.exists(src) & !file.exists(dest)]
  if (nrow(packages) == 0) return(invisible(NULL))

  message("Extracting functions")
  cl <- InitCluster("code.functions", "code.log", n=cluster.size)
  t <- system.time({
    clusterMap(cl, function(src, repo, ref) {
      dest <- file.path(datadir, "functions", src, repo, sprintf("%s.rds", ref))
      src <- file.path(datadir, "code", src, repo, sprintf("%s.rds", ref))
      dir.create(dirname(dest), recursive=TRUE)
      saveRDS(extractoR.content::FunctionDefinitions(readRDS(src)), dest)
    }, packages$source, packages$repository, packages$ref)
  })
  message(sprintf("Functions extracted in %.3fs", t[3]))
  stopCluster(cl)
}

ExtractFunctionCalls <- function(datadir, cluster.size=6) {
  packages <- readRDS(file.path(datadir, "rds", "packages.rds"))
  src <- packages[, file.path(datadir, "code", source, repository,
                              sprintf("%s.rds", ref))]
  dest <- packages[, file.path(datadir, "calls", source, repository,
                               sprintf("%s.rds", ref))]
  packages <- packages[file.exists(src) & !file.exists(dest)]
  if (nrow(packages) == 0) return(invisible(NULL))

  message("Extracting function calls")
  cl <- InitCluster("code.calls", "code.log", n=cluster.size)
  t <- system.time({
    clusterMap(cl, function(src, repo, ref) {
      dest <- file.path(datadir, "calls", src, repo, sprintf("%s.rds", ref))
      src <- file.path(datadir, "code", src, repo, sprintf("%s.rds", ref))
      dir.create(dirname(dest), recursive=TRUE)
      res <- tryCatch(extractoR.content::FunctionCalls(readRDS(src)),
                      error=function(e) e)
      saveRDS(res, dest)
    }, packages$source, packages$repository, packages$ref)
  })
  message(sprintf("Function calls extracted in %.3fs", t[3]))
  stopCluster(cl)
}

ExtractCodingStyle <- function(datadir, cluster.size=6) {
  packages <- readRDS(file.path(datadir, "rds", "packages.rds"))
  src <- packages[, file.path(datadir, "code", source, repository,
                              sprintf("%s.rds", ref))]
  dest <- packages[, file.path(datadir, "codingstyle", source, repository,
                               sprintf("%s.rds", ref))]
  packages <- packages[file.exists(src) & !file.exists(dest)]
  if (nrow(packages) == 0) return(invisible(NULL))

  message("Extracting coding style")
  cl <- InitCluster("code.codingstyle", "code.log", n=cluster.size)
  t <- system.time({
    clusterMap(cl, function(src, repo, ref) {
      dest <- file.path(datadir, "codingstyle", src, repo, sprintf("%s.rds", ref))
      src <- file.path(datadir, "code", src, repo, sprintf("%s.rds", ref))
      dir.create(dirname(dest), recursive=TRUE)
      saveRDS(extractoR.content::CodingStyle(readRDS(src)), dest)
    }, packages$source, packages$repository, packages$ref)
  })
  message(sprintf("Coding style extracted in %.3fs", t[3]))
  stopCluster(cl)
}
