FetchCRANList <- function(cran.mirror="http://cran.r-project.org") {
  FetchPageLinks <- function(url) {
    # Fetches all links values from a web page.
    url <- HTTPGetURL(url)
    message(sprintf("Parsing %s", url))
    doc <- HTTPGetFile(url)
    doc = htmlTreeParse(doc, asText=TRUE, useInternalNodes=TRUE)
    xpathSApply(doc, "//a[@href]", xmlValue)
  }

  ParseFilename <- function(filenames) {
    data.table(package=gsub("(.*)_(.*)\\.tar\\.gz", "\\1", filenames),
               version=gsub("(.*)_(.*)\\.tar\\.gz", "\\2", filenames),
               filename=filenames)
  }

  FetchCurrentFilenames <- function(cran.mirror) {
    filenames <- FetchPageLinks(file.path(cran.mirror, "src/contrib"))
    filenames <- grep(".*_.*\\.tar\\.gz$", filenames, value=TRUE)
    ParseFilename(filenames)[, list(package, version)]
  }

  FetchCurrent <- function(cran.mirror="http://cran.r-project.org") {
    dest <- tempfile()
    src <- file.path(cran.mirror, "src", "contrib", "Meta", "current.rds")
    download.file(src, dest)
    res <- readRDS(dest)[c("size", "mtime")]
    file.remove(dest)
    res$package <- rownames(res)
    as.data.table(res)[, archived := FALSE]
  }

  FetchArchived <- function(current=NULL,
                            cran.mirror="http://cran.r-project.org") {
    # If current is not NULL then package that are present in current
    # are removed from the list of archived packages
    dest <- tempfile()
    src <- file.path(cran.mirror, "src", "contrib", "Meta", "archive.rds")
    download.file(src, dest)
    res <- rbindlist(lapply(readRDS(dest), function(package) {
      package$filename <- sapply(strsplit(rownames(package), "/"),
                                 function(p) p[2])
      as.data.table(package)
    }))
    file.remove(dest)
    res <- merge(ParseFilename(res$filename), res, by="filename")
    res[, list(package, version, size, mtime)][, archived := TRUE]
  }

  # Fetches the list of all package archives (archived, non-archived) of CRAN.
  current <- merge(FetchCurrentFilenames(cran.mirror),
                   FetchCurrent(cran.mirror), by="package")
  archived <- FetchArchived(current, cran.mirror)
  res <- rbind(current, archived)
  # Removing duplicates
  res[res[, .I[which.max(mtime)], by=c("package", "version")]$V1]
}

FetchPackage <- function(package, version, datadir,
                         cran.mirror="http://cran.r-project.org") {

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

  dest <- file.path(datadir, package, version)
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
