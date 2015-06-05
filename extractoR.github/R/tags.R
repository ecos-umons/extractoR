ListRepositoryTags <- function(owner, repo, root.dir=".") {
  RunGit(function() {
    loginfo("Looking for tags for %s/%s",
            owner, repo, logger="git.tags")
    tags <- system2("git", "tag", stdout=TRUE)
    rbindlist(lapply(tags, function(tag) {
      res <- system2("git", c("show", "-s", "--pretty=format:\"%H %ci\""),
                     stdout=TRUE)
      cbind(data.table(owner=owner, repository=repo, tag),
            ParseCommit(res[length(res)]))
    }))
  }, root.dir)
}

RepositoryTags <- function(github, datadir) {
  github[, root.dir := file.path(datadir, owner, repository)]
  github <- setkey(unique(github[file.exists(root.dir),
                                 list(owner, repository, root.dir)]), root.dir)
  rbindlist(mapply(ListRepositoryTags, github$owner, github$repository,
                   github$root.dir))
}
