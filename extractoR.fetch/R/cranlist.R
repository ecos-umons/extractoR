FetchCurrent <- function(cran.mirror="http://cran.r-project.org") {
  dest <- tempfile()
  src <- file.path(cran.mirror, "src", "contrib", "Meta", "current.rds")
  download.file(src, dest)
  res <- readRDS(dest)[c("size", "mtime")]
  file.remove(dest)
  res$filename <- rownames(res)
  res[c("filename", "size", "mtime")]
}

FetchArchived <- function(current=NULL,
                          cran.mirror="http://cran.r-project.org") {
  # If current is not NULL then package that are present in current
  # are removed from the list of archived packages
  dest <- tempfile()
  src <- file.path(cran.mirror, "src", "contrib", "Meta", "archive.rds")
  download.file(src, dest)
  res <- FlattenDF(readRDS(dest), keep.rownames=TRUE)[c("size", "mtime")]
  file.remove(dest)
  res$filename <- sapply(strsplit(rownames(res), "/"),
                         function(x) x[length(x)])
  if (!is.null(current)) {
    res <- res[!res$filename %in% intersect(current$filename, res$filename), ]
  }
  res[c("filename", "size", "mtime")]
}

FetchCRANList <- function(cran.mirror="http://cran.r-project.org") {
  # Fetches the list of all package archives (archived, non-archived
  # and recommded in all R's versions) of CRAN.
  current <- FetchCurrent(cran.mirror)
  archived <- FetchArchived(current, cran.mirror)
  archived <- archived[!archived$filename %in% current$filename, ]
  packages <- rbind(current, archived)
  rversions <- FetchRVersions(cran.mirror)
  recommended <- rversions[!rversions$filename %in% packages$filename, ]
  packages <- rbind(packages, data.frame(filename=unique(recommended$filename),
                                         size=NA, mtime=NA))
  pnames <- sapply(packages$filename, ParseArchiveName)
  packages$package <- as.character(pnames[1, ])
  packages$version <- as.character(pnames[2, ])
  cols <- c("package", "version", "filename", "size", "mtime")
  list(packages=packages[cols], rversions=unique(rversions$rversion))
}
