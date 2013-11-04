FetchCurrent <- function(cran.mirror="http://cran.r-project.org") {
  dest <- tempfile()
  src <- file.path(cran.mirror, "src", "contrib", "Meta", "current.rds")
  download.file(src, dest)
  res <- readRDS(dest)[c("size", "mtime")]
  file.remove(dest)
  res$filename <- rownames(res)
  res
}

FetchArchived <- function(current=NULL,
                          cran.mirror="http://cran.r-project.org") {
  # If current is not NULL then package that are present in current
  # are removed from the list of archived packages
  dest <- tempfile()
  src <- file.path(cran.mirror, "src", "contrib", "Meta", "archive.rds")
  download.file(src, dest)
  res <- dflist2df(readRDS(dest))[c("size", "mtime")]
  file.remove(dest)
  rownames(res) <- sapply(strsplit(rownames(res), "/"),
                          function(x) x[length(x)])
  res$filename <- rownames(res)
  if (!is.null(current)) {
    res <- res[!rownames(res) %in% intersect(rownames(current), rownames(res)), ]
  }
  res
}

FetchCRANList <- function(cran.mirror="http://cran.r-project.org") {
  # Fetches the list of all package archives (archived, non-archived
  # and recommded in all R's versions) of CRAN.
  current <- FetchCurrent(cran.mirror)
  archived <- FetchArchived(cran.mirror)
  rversions <- FetchRVersions(cran.mirror)
  list(current=current, rversions=rversions, archived=archived)
}
