ExtractHttpLog <- function(logfile) {
  log <- read.csv2(logfile, stringsAsFactors=FALSE)
  log <- log[!is.na(log$r_version) & !is.na(log$r_arch) & !is.na(log$r_os) &
             !is.na(log$version) & !is.na(log$package), ]
  log$date <- paste(log$date, log$time)
  log$time <- NULL
  log
}
