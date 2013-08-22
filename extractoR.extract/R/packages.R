packages.df <- function(packages) {
  l <- sapply(unique(unlist(packages)), archive.parse.name)
  df <- data.frame(t(matrix(unlist(l), nrow=2)), stringsAsFactors=FALSE)
  names(df) <- c("package", "version")
  df
}

rversion.extract <- function(rversion, packages) {
  packages <- sapply(packages, archive.parse.name)
  data.frame(package=unlist(packages[1,]), version=unlist(packages[2,]),
             rversion=rep(rversion, ncol(packages)))
}

rversions.extract <- function(rversions) {
  rversions <- mapply(function(v, p)rversion.extract(v, p),
                      names(rversions), rversions, SIMPLIFY=FALSE)
  dflist2df(rversions, c("package", "version", "rversion"))
}
