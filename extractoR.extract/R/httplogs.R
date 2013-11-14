ExtractHttpLog <- function(logfile) {
  log <- read.csv2(logfile)
  log$date <- paste(log$date, log$time)
  log$time <- NULL
  log
}
