LogDescfile <- function(owner, repo, subdir, root.dir=".") {
  loginfo("Log DESCRIPTION file for %s:%s:%s", owner, repo, subdir,
          logger="index.github")
  commits <- LogFile("DESCRIPTION", subdir, root.dir)
  if (!ParseRef("HEAD", root.dir) %in% commits$commit) {
      commits <- rbind(LogFile(".", subdir, root.dir, limit=1), commits)
  }
  if (nrow(commits)) {
    cbind(owner=owner, repository=repo, subdir, commits)
  }
}

MakeRepositoryId <- function(owner, repo, subdir) {
  ids <- sprintf("%s/%s", owner, repo)
  normalized <- normalizePath(subdir, mustWork=FALSE)
  has.subdir <- !is.na(subdir) & normalized != getwd()
  ids[has.subdir] <- sprintf("%s/%s", ids[has.subdir], subdir[has.subdir])
  ids
}

RepositoryTags <- function(owner, repo, subdir, root.dir=".") {
  loginfo("Looking for tags for %s/%s/%s",
          owner, repo, subdir, logger="git.tags")
  tags <- RunGit(function() system2("git", "tag", stdout=TRUE), root.dir)
  rbindlist(lapply(tags, function(tag) {
    commits <- LogFile(".", subdir, root.dir, tag, 1)
    if (nrow(commits)) {
      cbind(owner=owner, repository=repo, subdir=subdir, commits, tag=tag)
    }
  }))
}

MakeRepositoryIndex <- function(owner, repo, subdir, root.dir) {
  commits <- LogDescfile(owner, repo, subdir, root.dir)
  commits[, tag := NA]
  tags <- RepositoryTags(owner, repo, subdir, root.dir)
  rbind(commits[!commit %in% tags], tags)
}

MakeGithubIndex <- function(github, datadir,
                            ignore=c("cran", "rpkg", "Bioconductor-mirror", "rforge")) {
  github <- setkey(github[!owner %in% ignore], owner, repository, subdir)
  github[, root.dir := file.path(datadir, owner, repository)]
  github <- github[file.exists(file.path(root.dir, "DESCRIPTION"))]
  logs <- rbindlist(with(github, mapply(MakeRepositoryIndex, owner, repository,
                                        subdir, root.dir, SIMPLIFY=FALSE)))
  logs <- merge(github, setkey(logs, owner, repository, subdir))
  ids <- logs[, MakeRepositoryId(owner, repository, subdir)]
  logs[, list(source="github", repository=ids, ref=commit,
              time=as.POSIXct(date))]
}
