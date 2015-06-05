LogDescfile <- function(owner, repo, subdir, root.dir=".") {
  RunGit(function() {
    loginfo("Fetching DESCRIPTION history for %s/%s",
            owner, repo, logger="git.log")
    res <- system2("git", c("log", "--pretty=format:\"%H %ci\"", "--",
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

MakeGithubIndex <- function(github, datadir,
                            ignore=c("cran", "rpkg", "Bioconductor-mirror")) {
  github <- setkey(github[!owner %in% ignore], owner, repository, subdir)
  github[, root.dir := file.path(datadir, owner, repository)]
  github <- github[file.exists(file.path(root.dir, "DESCRIPTION"))]

  logs <- rbindlist(mapply(LogDescfile, github$owner, github$repo,
                           github$subdir, github$root.dir, SIMPLIFY=FALSE))
  logs <- merge(github, setkey(logs, owner, repository, subdir))
  ids <- logs[, MakeRepositoryId(owner, repository, subdir)]
  logs[, list(source="github", repository=ids, version=commit, time=date)]
}
