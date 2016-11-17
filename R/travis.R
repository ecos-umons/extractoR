MakeTravisIndex <- function(index, datadir) {
  repos <- ParseGithubRepositoryName(index[source == "github",
                                           unique(repository)])
  with(repos, rbindlist(mapply(function(owner, repo, subdir, root.dir=".") {
    LogFile(".travis.yml", owner, repo, subdir, root.dir)
  }, owner, repository, subdir, file.path(datadir, owner, repository), SIMPLIFY=FALSE)))
}
