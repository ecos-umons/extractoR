CheckURL <- function(url) {
  h = getCurlHandle()
  getURL(url, header=1,nobody=1, curl = h)
  as.logical(getCurlInfo(h, "response.code") == 200)
}

GetURL <- function(package, filename, rversions) {
  urls <- file.path("http://cran.r-project.org/src/contrib",
                    c(file.path("Archive", package), "",
                      file.path(rversions, "Recommended")))
  urls <- file.path(urls, filename)
  for(url in urls) {
    if (CheckURL(url)) return(url)
  }
}

FetchArchive <- function(package, filename, rversions, datadir) {
  dest <- file.path(datadir, filename)
  url <- GetURL(package, filename, rversions)
  if (length(url)) {
    download.file(url, dest, method="wget")
    dest
  } else {
    warning(sprintf("Can't download %s", filename))
    NULL
  }
}

FetchPackage <- function(filename, rversions, datadir) {
  archive <- ParseArchiveName(filename)
  dest <- file.path(datadir, archive$package, archive$version)
  if(!file.exists(dest)) {
    res <- FetchArchive(archive$package, filename, rversions, datadir)
    if(length(res)) {
      untar(res, exdir=dest)
      file.remove(res)
      return(TRUE)
    }
  }
  FALSE
}

FetchPackages <- function(packages, datadir) {
  rversions <- names(packages$rversions)
  sapply(unique(unlist(packages)), FetchPackage, rversions, datadir)
}
