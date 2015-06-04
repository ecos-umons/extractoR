MakeCRANIndex <- function(packages) {
  packages[, list(source="cran", repository=package, version, time=mtime)]
}
