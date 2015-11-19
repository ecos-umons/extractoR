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
