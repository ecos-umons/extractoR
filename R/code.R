ParsePackage <- function(source, repository, ref, datadir) {
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

  dir <- file.path(datadir, source)
  if (source == "cran") {
    res <- ParseCRANPackage(repository, ref, file.path(dir, "packages"))
  } else if (source == "github") {
    res <- ParseGithubPackage(repository, ref, file.path(dir, "repos"))
  } else {
    stop(sprintf("Unknown source: %s", src))
  }
  data <- list(source=source, repository=repository, ref=ref)
  if (inherits(res, "package.code")) {
    data$code <- res
  } else if (inherits(res, "error")) {
    data$err <- res
  } else if (!is.null(res)) {
    stop("Unknown result")
  }
  data
}

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
        saveRDS(ParsePackage(src, repo, ref, datadir), dest)
      }
    }, source, repository, ref))
  })
  message(sprintf("Package code parsed in %.3fs", t[3]))
}

FunctionDefinitions <- function(package) {
  loginfo("Extracting R functions from package %s %s %s",
          package$source, package$repository, package$ref, logger="functions")
  if (!is.null(package$code)) {
    package <- c(package, sourceR::FunctionDefinitions(package$code))
  }
  package$code <- NULL
  package
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
        res <- try(FunctionDefinitions(code))
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

FunctionCalls <- function(package) {
  loginfo("Extracting R function calls from package %s %s %s",
          package$source, package$repository, package$ref, logger="functions")
  if (!is.null(package$code)) {
    calls <- sourceR::FunctionCalls(package$code)
    if (!is.null(calls)) {
      package <- c(package, calls)
      package$code <- NULL
      package
    }
  }
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
        res <- try(FunctionCalls(code))
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

CodingStyle <- function(package) {
  loginfo("Parsing R functions from package %s %s %s",
          package$source, package$repository, package$ref, logger="functions")
  if (!is.null(package$code)) {
    package <- c(package, sourceR::CodingStyle(package$code))
  }
  package$code <- NULL
  package
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
        res <- try(CodingStyle(code))
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

ExplicitCalls <- function(source, repository, ref, datadir) {
  calls <- readRDS(sprintf("%s/calls/%s/%s/%s.rds",
                           datadir, source, repository, ref))
  if (!inherits(calls, "error") && length(calls) > 3) {
    loginfo("Explicit calls of %s:%s:%s", source, repository, ref,
            logger="calls.exlicit")
    as.data.table(calls)[!is.na(package)]
  }
}

ImplicitCalls <- function(source, repository, ref, datadir, deps.exports) {
  file <- sprintf("%s/%%s/%s/%s/%s.rds", datadir,
                  source, repository, ref)
  calls <- readRDS(sprintf(file, "calls"))
  funcs <- readRDS(sprintf(file, "functions"))$functions
  if (!inherits(calls, "error") && length(calls) > 3) {
    loginfo("Implicit calls of %s:%s:%s", source, repository, ref,
            logger="calls.implicit")
    calls <- as.data.table(calls)[is.na(package)]
    package <- list(source, repository, ref)
    res1 <- if (nrow(funcs)) calls[name %in% funcs[!is.na(name) & global, name]]
    res2 <- calls[name %in% deps.exports[!export %in% res1$name, export]]
    list(self=res1, other=res2)
  }
}

# FIXME
## ResolveFunctionCalls <- function(datadir) {
##   packages <- readRDS(file.path(datadir, "rds", "packages.rds"))
##   exports <- readRDS(file.path(datadir, "rds", "exports_expanded.rds"))
##   exports <- merge(exports, packages, by=c("source", "repository", "ref"))
##   deps <- readRDS(file.path(datadir, "rds", "deps.rds"))
##   deps <- deps[type.name %in% c("imports", "depends", "linkingto")]
##   setkey(deps, source, repository, ref, dependency)

##   src1 <- packages[, file.path(datadir, "functions", source, repository,
##                                sprintf("%s.rds", ref))]
##   src2 <- packages[, file.path(datadir, "calls", source, repository,
##                                sprintf("%s.rds", ref))]
##   dest1 <- packages[, file.path(datadir, "calls-implicit", source, repository,
##                                 sprintf("%s.rds", ref))]
##   dest2 <- packages[, file.path(datadir, "calls-explicit", source, repository,
##                                 sprintf("%s.rds", ref))]
##   packages <- packages[file.exists(src1) & file.exists(src2) &
##                        !file.exists(dest1) & !file.exists(dest2)]
##   if (nrow(packages) == 0) return(invisible(NULL))

##   message("Resolving function calls")
##   t <- system.time({
##     mapply(function(src, repo, ref) {
##       dest <- file.path(datadir, "calls-explicit", src, repo,
##                         sprintf("%s.rds", ref))
##       dir.create(dirname(dest), recursive=TRUE)
##       res <- ExplicitCalls(src, repo, ref, datadir)
##       saveRDS(res, dest)

##       dest <- file.path(datadir, "calls-implicit", src, repo,
##                         sprintf("%s.rds", ref))
##       dir.create(dirname(dest), recursive=TRUE)
##       deps.exports <- exports[package %in% deps[list(src, repo, ref),
##                                                 unique(dependency)]]
##       res <- ImplicitCalls(src, repo, ref, datadir,
##                            deps.exports)
##       saveRDS(res, dest)
##     }, packages$source, packages$repository, packages$ref)
##   })
##   message(sprintf("Function calls resolved in %.3fs", t[3]))
## }
