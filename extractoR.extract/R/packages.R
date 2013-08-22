packages.df <- function(packages) {
  l <- sapply(unique(unlist(p)), function(x) archive.parse.name(x))
  df <- data.frame(t(matrix(unlist(l), nrow=2)), stringsAsFactors=FALSE)
  names(df) <- c("package", "version")
  df
}
