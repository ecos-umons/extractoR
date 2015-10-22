LogDescfile <- function(owner, repo, subdir, root.dir=".") {
  LogFile("DESCRIPTION", owner, repo, subdir, root.dir)
}

MakeRepositoryId <- function(owner, repo, subdir) {
  ids <- sprintf("%s/%s", owner, repo)
  normalized <- normalizePath(subdir, mustWork=FALSE)
  has.subdir <- !is.na(subdir) & normalized != getwd()
  ids[has.subdir] <- sprintf("%s/%s", ids[has.subdir], subdir[has.subdir])
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
  logs[, list(source="github", repository=ids, ref=commit, time=date)]
}
