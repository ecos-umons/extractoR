library(RCurl)

urls <- c("http://cran.r-project.org/src/contrib",
          "http://cran.r-project.org/src/contrib/Archive")

archive.name <- function(package, version) {
  paste(paste(package, version, sep="_"), "tar.gz", sep=".")
}

check.url <- function(url) {
  h = getCurlHandle()
  getURL(url, header=1,nobody=1, curl = h)
  as.logical(getCurlInfo(h, "response.code") == 200)
}

get.url <- function(package, filename) {
  urls <- file.path(c(urls, file.path(urls, package)), filename)
  for(url in urls) {
    if(check.url(url)) return(url)
  }
}

download.archive <- function(package, filename, datadir) {
  dest <- file.path(datadir, filename)
  url <- get.url(package, filename)
  if(length(url)) {
    download.file(url, dest, method="wget")
    dest
  } else {
    NULL
  }
}

fetch.archive <- function(version, package, datadir) {
  filename <- archive.name(package, version)
  dest <- file.path(datadir, package, version)
  if(!file.exists(dest)) {
    res <- download.archive(package, filename, datadir)
    if(length(res)) {
      untar(res, files=package, exdir=dest)
      file.remove(res)
      return(TRUE)
    }
  }
  FALSE
}

fetch.package <- function(package, datadir) {
  sapply(package$versions, fetch.archive, package$name, datadir)
}

fetch.packages <- function(packages, datadir) {
  sapply(packages, fetch.package, datadir)
}
