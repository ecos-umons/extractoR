FetchRecommendedList <- function(rversion,
                                 cran.mirror="http://cran.r-project.org") {
  # Fetches the list of recommended package archives for a specific
  # R's version.
  url <- file.path(cran.mirror, "src/contrib/%s/Recommended")
  links <- FetchPageLinks(sprintf(url, rversion))
  packages <- grep("\\.tar\\.gz$", links, value=TRUE)
  res <- ParseFilename(packages)
  res$rversion <- rversion
  res[, list(rversion, package, version)]
}

FetchRVersions <- function(cran.mirror="http://cran.r-project.org") {
  links <- FetchPageLinks(file.path(cran.mirror, "src/contrib/"))
  rversions <- sub("/$", "", grep("^[0-9]+\\.[0-9]+.*/$", links, value=TRUE))
  rbindlist(lapply(rversions, FetchRecommendedList, cran.mirror))
}
