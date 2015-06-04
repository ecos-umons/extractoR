LogDescfile <- function(owner, repo, subdir, root.dir=".") {
  RunGit(function() {
    loginfo("Fetching DESCRIPTION history for %s/%s",
            owner, repo, logger="git.log")
    res <- system2("git", c("log", "--pretty=format:\"%H %ci\"",
                            file.path(subdir, "DESCRIPTION")),
                   stdout=TRUE)
    data.table(owner=owner, repository=repo, subdir,
               commit=sub("^([^ ]+) (.*)$", "\\1", res),
               date=ParseDate(sub("^([^ ]+) (.*)$", "\\2", res)))
  }, root.dir)
}

MakeRepositoryId <- function(owner, repo, subdir) {
  ids <- sprintf("%s:%s", owner, repo)
  normalized <- normalizePath(subdir, mustWork=FALSE)
  has.subdir <- !is.na(subdir) & normalized != getwd()
  ids[has.subdir] <- sprintf("%s:%s", ids[has.subdir], subdir[has.subdir])
  ids
}

MakeGithubIndex <- function(github, datadir) {
  repos <- repos[!owner %in% c("cran", "rpkg")]
  root.dirs <- file.path(datadir, "github", "repos", owner, repository)
  repos <- repos[file.exists(file.path(root.dirs, "DESCRIPTION"))]
  repos <- repos[]
  setkey(repos, owner, repository, subdir)

  logs <- rbindlist(mapply(LogDescfile, repos$owner, repos$repo,
                           repos$subdir, root.dirs, SIMPLIFY=FALSE))
  logs <- merge(repos, setkey(logs, owner, repository, subdir))
  logs[, list(source="github", repository=MakeRepositoryId(owner, repo, subdir),
              version=commit, time=date)]
}
