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

# Run a git log on a file
LogFile <- function(file, subdir=".", root.dir=".", limit=0) {
  RunGit(function() {
    logdebug("Fetching %s history for %s", root.dir, logger="git.log")
    args <- c("log", "--pretty=format:\"%H %ci\"")
    if (limit) args <- c(args, "-n", sprintf("%d", limit))
    args <- c(args, "--", file.path(subdir, file))
    res <- system2("git", args, stdout=TRUE)
    ParseCommit(res)
  }, root.dir)
}

Head <- function(root.dir=".") {
  RunGit(function() {
    logdebug("Parsing HEAD for %s", root.dir, logger="git.log")
    system2("git", c("rev-parse", "HEAD"), stdout=TRUE)
  }, root.dir)
}
