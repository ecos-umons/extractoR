library(data.table)
library(extractoR.data)

datadir <- "/data/rdata"

index <- readRDS("/data/rdata/rds/index.rds")
packages <- readRDS("/data/rdata/rds/packages.rds")
namespaces <- readRDS("/data/rdata/rds/namespaces.rds")
functions <- readRDS("/data/rdata/rds/functions.rds")[!is.na(name) & global]

names(namespaces) <- paste(sub("/", ":", sub("^(.+)/([^/]+)$", "\\1", names(namespaces))),
                           sub("^(.+)/([^/]+)$", "\\2", names(namespaces)), sep=":")

Imports <- function(namespaces) {
  rbindlist(mapply(function(repo, namespace) {
    repo <- ParseRepositoryId(repo)
    if (length(namespace$imports)) {
      cbind(repo, rbindlist(lapply(namespace$imports, function(import) {
        if (length(import) == 2 && length(import[[2]])) {
          data.table(package=import[[1]], object=unlist(import[[2]]))
        } else {
          data.table(package=import[[1]], object=NA)
      }
      })))
    }
  }, names(namespaces), namespaces, SIMPLIFY=FALSE))
}

ExpandExports <- function(exports) {
  exports <- split(exports, exports$pattern)
  expand <- merge(exports[["TRUE"]], functions,
                  by=c("source", "repository", "ref"))
  expand <- split(expand, expand$export)
  expand <- rbindlist(lapply(names(expand), function(re) {
    expand[[re]][grep(re, name), list(source, repository, ref, export=name)]
  }))
  exports[["FALSE"]][, list(source, repository, ref, export)]
}

Exports <- function(namespaces) {
  res <- mapply(function(repo, namespace) {
    repo <- ParseRepositoryId(repo)
    res1 <- if (length(namespace$exports)) {
      cbind(repo, pattern=FALSE, export=namespace$exports)
    }
    res2 <- if (length(namespace$exportPatterns)) {
      cbind(repo, pattern=TRUE, export=namespace$exportPatterns)
    }
    rbind(res1, res2)
  }, names(namespaces), namespaces, SIMPLIFY=FALSE)
  ExpandExports(rbindlist(res))
}

imports <- Imports(namespaces)
saveRDS(imports, file.path(datadir, "rds/imports.rds"))

exports <- Exports(namespaces)
saveRDS(exports, file.path(datadir, "rds/exports.rds"))
