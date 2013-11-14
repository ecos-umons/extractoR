FetchLogsList <- function(url) {
  links <- FetchPageLinks(url)
  dates <- grep("^\\d\\d\\d\\d-\\d\\d-\\d\\d$", links, value=TRUE)
  year <- as.POSIXlt(dates)$year + 1900
  urls <- file.path(url, year, paste0(dates, ".csv.gz"))
  names(urls) <- paste0(dates, ".csv")
  urls
}

DownloadLog <- function(log, datadir) {
  tmpfile <- tempfile()
  download.file(log, tmpfile, method="wget")
  write.csv2(read.csv(gzfile(tmpfile)), file.path(datadir, names(log)))
  file.remove(tmpfile)
}

DownloadMissingLogs <- function(logs, datadir) {
  path <- file.path(datadir, "logs")
  current <- dir(path)
  missings <- logs[setdiff(names(logs), current)]
  for (missing in names(missings)) {
    DownloadLog(missings[missing], path)
  }
}
