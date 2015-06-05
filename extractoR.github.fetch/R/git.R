RunGit <- function(FUNC, directory) {
  tmp <- getwd()
  setwd(directory)
  res <- FUNC()
  setwd(tmp)
  res
}

ParseDate <- function(date) {
  strftime(strptime(date, tz="UTC", "%Y-%m-%d %H:%M:%S %z"),
           format="%Y-%m-%d %H:%M:%S")
}
