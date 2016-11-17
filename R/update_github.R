MakeGithubIndex <- function(github, datadir,
                            ignore=c("cran", "rpkg", "Bioconductor-mirror", "rforge")) {
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

  github <- setkey(github, owner, repository, subdir)
  github[, root.dir := file.path(datadir, owner, repository)]
  github <- github[file.exists(file.path(root.dir, "DESCRIPTION"))]
  logs <- rbindlist(with(github, mapply(MakeRepositoryIndex, owner, repository,
                                        subdir, root.dir, SIMPLIFY=FALSE)))
  logs <- merge(github, setkey(logs, owner, repository, subdir))
  ids <- logs[, MakeRepositoryId(owner, repository, subdir)]
  logs[, list(source="github", repository=ids, ref=commit,
              time=as.POSIXct(date))]
}

TestGithubRepository <- function(owner, name, subdir=".", filter.only=TRUE) {
  # Check whether a given Github repository exists
  # If filter.only is TRUE, the function returns a boolean telling
  # whether the repository is a R package. Otherwise it returns a
  # data.table with the repository infos if the repository is a R package.
  loginfo("Checking %s/%s/%s", owner, name, subdir, logger="github.test")
  url <- sprintf("https://github.com/%s/%s/blob/master/%s/DESCRIPTION",
                 owner, name, subdir)
  url <- HTTPGetURL(url)
  if (filter.only) {
    !is.na(url)
  } else if (!is.na(url)) {
    owner <- sub("^https://github.com/([^/]+)/([^/]+)/.*$", "\\1", url)
    name <- sub("^https://github.com/([^/]+)/([^/]+)/.*$", "\\2", url)
    data.table(owner, repository=name, subdir)
  }
}

FetchGithubRepository <- function(owner, name, datadir, update=TRUE) {
  # Clone a given repository if it hasn't been cloned before,
  # otherwise update it (if boolean is true)
  url <- sprintf("https://github.com/%s/%s.git", owner, name)
  dest <- file.path(datadir, owner, name)
  if (HTTPCheck(url)) {
    if (!file.exists(dest)) {
      loginfo("Cloning %s/%s", owner, name, logger="github.download")
      system2("git", c("clone", url, dest))
    } else if (update) {
      loginfo("Updating %s/%s", owner, name, logger="github.download")
      tmp <- getwd()
      setwd(dest)
      system2("git", c("fetch", "-f", "-p", "origin"))
      setwd(tmp)
    }
  }
  invisible(NULL)
}
