MakeCRANIndex <- function(packages) {
  packages[, list(source="cran", repository=package, ref=version, time=mtime)]
}
