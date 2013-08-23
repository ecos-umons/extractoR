GetPackagesDataframe <- function(packages) {
  l <- sapply(unique(unlist(packages)), ParseArchiveName)
  df <- data.frame(t(matrix(unlist(l), nrow=2)), stringsAsFactors=FALSE)
  names(df) <- c("package", "version")
  df
}

ExtractRversion <- function(rversion, packages) {
  packages <- sapply(packages, ParseArchiveName)
  data.frame(package=unlist(packages[1, ]), version=unlist(packages[2, ]),
             rversion=rep(rversion, ncol(packages)))
}

ExtractRversions <- function(rversions) {
  rversions <- mapply(function(v, p) ExtractRversion(v, p),
                      names(rversions), rversions, SIMPLIFY=FALSE)
  dflist2df(rversions, c("package", "version", "rversion"))
}
