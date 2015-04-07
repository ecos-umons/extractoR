FetchPageLinks <- function(url) {
  # Fetches all links values from a web page.
  message(sprintf("Parsing %s", url))
  doc = htmlTreeParse(url, useInternalNodes=T)
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

FetchCRANList <- function(cran.mirror="http://cran.r-project.org") {
  # Fetches the list of all package archives (archived, non-archived) of CRAN.
  current <- merge(FetchCurrentFilenames(cran.mirror),
                   FetchCurrent(cran.mirror), by="package")
  archived <- FetchArchived(current, cran.mirror)
  rbind(current, archived)
}
