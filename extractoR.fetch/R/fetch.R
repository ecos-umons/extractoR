check.url <- function(url) {
  h = getCurlHandle()
  getURL(url, header=1,nobody=1, curl = h)
  as.logical(getCurlInfo(h, "response.code") == 200)
}

get.url <- function(package, filename, rversions) {
  urls <- file.path("http://cran.r-project.org/src/contrib",
                    c(file.path("Archive", package), "",
                      file.path(rversions, "Recommended")))
  urls <- file.path(urls, filename)
  for(url in urls) {
    if(check.url(url)) return(url)
  }
}

fetch.archive <- function(package, filename, rversions, datadir) {
  dest <- file.path(datadir, filename)
  url <- get.url(package, filename, rversions)
  if(length(url)) {
    download.file(url, dest, method="wget")
    dest
  } else {
    warning(sprintf("Can't download %s", filename))
    NULL
  }
}

fetch.package <- function(filename, rversions, datadir) {
  archive <- archive.parse.name(filename)
  dest <- file.path(datadir, archive$package, archive$version)
  if(!file.exists(dest)) {
    res <- fetch.archive(archive$package, filename, rversions, datadir)
    if(length(res)) {
      untar(res, exdir=dest)
      file.remove(res)
      return(TRUE)
    }
  }
  FALSE
}

fetch.packages <- function(packages, datadir) {
  rversions <- names(packages$rversions)
  sapply(unique(unlist(packages)), fetch.package, rversions, datadir)
}
