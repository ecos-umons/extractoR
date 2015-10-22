LogTravis <- function(owner, repo, subdir, root.dir=".") {
  LogFile(".travis.yml", owner, repo, subdir, root.dir)
}

MakeTravisIndex <- function(index, datadir) {
  repos <- ParseGithubRepositoryName(index[source == "github",
                                           unique(repository)])
  with(repos, rbindlist(mapply(LogTravis, owner, repository, subdir,
                               file.path(datadir, owner, repository),
                               SIMPLIFY=FALSE)))
}
