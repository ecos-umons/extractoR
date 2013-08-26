GetPackagesDataframe <- function(packages) {
  # Converts a list of packages to a dataframe.
  #
  # Args:
  #   packages: A list of package archives (like the one returned by
  #             FetchCRANList).
  #
  # Returns:
  #   A two column dataframe with packages name and version.
  l <- sapply(unique(unlist(packages)), ParseArchiveName)
  df <- data.frame(t(matrix(unlist(l), nrow=2)), stringsAsFactors=FALSE)
  names(df) <- c("package", "version")
  df
}

ExtractRversion <- function(rversion, packages) {
  # Extracts the list of recommended packages for a given R version.
  #
  # Args:
  #   packages: A list of package archives name.
  #
  # Returns:
  #   A three column dataframe with packages name, version and the
  #   rversion.
  packages <- sapply(packages, ParseArchiveName)
  data.frame(package=unlist(packages[1, ]), version=unlist(packages[2, ]),
             rversion=rep(rversion, ncol(packages)))
}

ExtractRversions <- function(packages) {
  # Extracts the list of recommended packages for all R versions.
  #
  # Args:
  #   packages: A list of package archives (like the one returned by
  #             FetchCRANList).
  #
  # Returns:
  #   A three column dataframe with packages name, version and the
  #   rversion.
  rversions <- packages$rversions
  rversions <- mapply(function(v, p) ExtractRversion(v, p),
                      names(rversions), rversions, SIMPLIFY=FALSE)
  dflist2df(rversions, c("package", "version", "rversion"))
}
