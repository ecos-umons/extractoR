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

ParseCommit <- function(commit) {
  data.table(commit=sub("^([^ ]+) (.*)$", "\\1", commit),
             date=ParseDate(sub("^([^ ]+) (.*)$", "\\2", commit)))
}
