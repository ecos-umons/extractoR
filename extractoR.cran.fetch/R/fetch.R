CheckURL <- function(url) {
  # Checks whether a given URL is valid (i.e. HTTP return code is 200)
  # using Curl.
  h <- getCurlHandle()
  getURL(url, header=1, nobody=1, curl = h)
  as.logical(getCurlInfo(h, "response.code") == 200)
}

GetURL <- function(package, version, cran.mirror="http://cran.r-project.org") {
  # Gets one valid URL (if any) for downloading a package archive.
  filename <- sprintf("%s_%s.tar.gz", package, version)
  urls <- file.path(cran.mirror, "src/contrib",
                    c("", file.path("Archive", package)))
  urls <- file.path(urls, filename)
  for(url in urls) {
    if (CheckURL(url)) return(url)
  }
}

FetchArchive <- function(package, version,
                         cran.mirror="http://cran.r-project.org") {
  # Downloads a package archive if there is any available.
  dest <- tempfile()
  message(sprintf("Fetching package %s %s", package, version))
  url <- GetURL(package, version, cran.mirror)
  if (length(url)) {
    download.file(url, dest, method="wget")
    dest
  } else {
    warning(sprintf("Can't download %s %s", package, version))
    character(0)
  }
}

FetchPackage <- function(package, version, datadir,
                         cran.mirror="http://cran.r-project.org") {
  dest <- file.path(datadir, "packages", package, version)
  if (!file.exists(dest)) {
    res <- FetchArchive(package, version, cran.mirror)
    if (length(res)) {
      untar(res, exdir=dest)
      file.remove(res)
      TRUE
    } else FALSE
    TRUE
  } else FALSE
}
