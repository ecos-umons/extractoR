TestGithubRepository <- function(owner, name, subdir=".") {
  url <- sprintf("https://github.com/%s/%s/blob/master/%s/DESCRIPTION",
                 owner, name, subdir)
  loginfo("Checking %s/%s/%s", owner, name, subdir, logger="github.test")
  HTTPCheck(url)
}

FetchGithubRepository <- function(owner, name, datadir, update=TRUE) {
  url <- sprintf("https://github.com/%s/%s.git", owner, name)
  dest <- file.path(datadir, owner, name)
  if (!file.exists(dest)) {
    loginfo("Cloning %s/%s", owner, name, logger="github.download")
    if (HTTPCheck(url)) {
      system2("git", c("clone", url, dest))
    }
  } else if (update) {
    loginfo("Updating %s/%s", owner, name, logger="github.download")
    if (HTTPCheck(url)) {
      tmp <- getwd()
      setwd(dest)
      system2("git", c("fetch", "-p", "origin"))
      setwd(tmp)
    }
  }
  invisible(NULL)
}
