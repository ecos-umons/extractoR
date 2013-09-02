CheckURL <- function(url) {
  # Checks whether a given URL is valid (i.e. HTTP return code is 200)
  # using Curl.
  #
  # Args:
  #   URL: The URL to check.
  #
  # Returns:
  #   TRUE iff the HTTP return code is 200.
  h = getCurlHandle()
  getURL(url, header=1, nobody=1, curl = h)
  as.logical(getCurlInfo(h, "response.code") == 200)
}

GetURL <- function(package, filename, rversions,
                   cran.mirror="http://cran.r-project.org") {
  # Gets one valid URL (if any) for downloading a package archive.
  #
  # Args:
  #   package: The package name.
  #   filename: The filename of the archive.
  #   rversions: If this archive is not in src/contrib and
  #              src/contrib/Archive, this vector of rversions will be
  #              used for searching for in the recommended packages.
  #   cran.mirror: Root URL of the CRAN mirror to use.
  #
  # Returns:
  #   The URL if any, else NULL.
  urls <- file.path(cran.mirror, "src/contrib",
                    c(file.path("Archive", package), "",
                      file.path(rversions, "Recommended")))
  urls <- file.path(urls, filename)
  for(url in urls) {
    if (CheckURL(url)) return(url)
  }
}

FetchArchive <- function(package, filename, rversions, datadir,
                         cran.mirror="http://cran.r-project.org") {
  # Downloads a package archive if there is any available.
  #
  # Args:
  #   package: The package name.
  #   filename: The filename of the archive.
  #   rversions: If this archive is not in src/contrib and
  #              src/contrib/Archive, this vector of rversions will be
  #              used for searching for in the recommended packages.
  #   datadir: Directory where to store the downloaded archive.
  #   cran.mirror: Root URL of the CRAN mirror to use.
  #
  # Returns:
  #   The path of the downloaded archive if any else NULL.
  dest <- file.path(datadir, filename)
  url <- GetURL(package, filename, rversions, cran.mirror)
  if (length(url)) {
    download.file(url, dest, method="wget")
    dest
  } else {
    warning(sprintf("Can't download %s", filename))
    NULL
  }
}

FetchPackage <- function(filename, rversions, datadir,
                         cran.mirror="http://cran.r-project.org") {
  # Downloads a package archive if there is any available and extracts
  # its content. If the package has already been previously downloaded
  # and extracted, it isn't downloaded/extracted again.
  #
  # Args:
  #   filename: The filename of the archive.
  #   rversions: If this archive is not in src/contrib and
  #              src/contrib/Archive, this vector of rversions will be
  #              used for searching for in the recommended packages.
  #   datadir: Directory where to store the downloaded archive and
  #            extract it (it will actually be extracted to
  #            datadir/<package_name>/<package_version>
  #   cran.mirror: Root URL of the CRAN mirror to use.
  #
  # Returns:
  #   TRUE if the package has been downloaded, FALSE if not.
  archive <- ParseArchiveName(filename)
  dest <- file.path(datadir, archive$package, archive$version)
  if (!file.exists(dest)) {
    res <- FetchArchive(archive$package, filename, rversions,
                        datadir, cran.mirror)
    if (length(res)) {
      untar(res, exdir=dest)
      file.remove(res)
      return(TRUE)
    }
  }
  FALSE
}

FetchPackages <- function(packages, datadir,
                          cran.mirror="http://cran.r-project.org") {
  # Downloads and extracts a list packages in datadir.
  #
  # Args:
  #   packages: A list of package archives (like the one returned by
  #   FetchCRANList).
  #   datadir: Directory where to store and extract the packages.
  #   cran.mirror: Root URL of the CRAN mirror to use.
  #
  # Returns:
  #   A logical vector telling where a value is TRUE iff the package
  #   has been donwloaded.
  rversions <- names(packages$rversions)
  sapply(unique(unlist(packages)),
         FetchPackage, rversions, datadir, cran.mirror)
}
