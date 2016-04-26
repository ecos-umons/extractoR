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
LogFile <- function(file, owner, repo, subdir, root.dir=".") {
  RunGit(function() {
    loginfo("Fetching %s history for %s/%s", file, owner, repo,
            logger="git.log")
    res <- system2("git", c("log", "--pretty=format:\"%H %ci\"", "--",
                            file.path(subdir, file)),
                   stdout=TRUE)
    res <- ParseCommit(res)
    if (nrow(res)) {
      cbind(owner=owner, repository=repo, subdir, res)
    }
  }, root.dir)
}
