CRANIndex <- function(datadir, cran.mirror="http://cran.r-project.org") {
  datadir <- file.path(datadir, "cran")

  message("Fetching CRAN list")
  t <- system.time(packages <- FetchCRANList(cran.mirror))
  message(sprintf("Package list fetched from CRAN in %.3fs", t[3]))

  index <- packages[, list(source="cran", repository=package, ref=version, time=mtime)]

  message("Downloading missing packages")
  t <- system.time(res <- mapply(FetchPackage, index$repository, index$ref,
                                 MoreArgs=list(file.path(datadir, "packages"), cran.mirror)))
  message(sprintf("%d packages downloaded in %.3fs",
                  if (length(res)) length(res[res]) else 0, t[3]))

  index
}

GithubIndex <- function(datadir, filter=TRUE, fetch=TRUE, update=TRUE,
                        cluster.size=4, ignore=c("cran", "rpkg", "Bioconductor-mirror", "rforge")) {
  datadir <- file.path(datadir, "github")
  reposdir <- file.path(datadir, "repos")
  filename <- file.path(datadir, "csv/repositories.csv")
  github <- as.data.table(read.csv(filename, stringsAsFactors=FALSE))
  setkey(github, owner, repository)

  if (filter) {
    github <- FilterGithubRepositories(github, TRUE, 3 * cluster.size)
    write.csv(github, filename, row.names=FALSE)
  }
  github <- github[!owner %in% ignore]
  github <- FilterGithubRepositories(github, FALSE, 3 * cluster.size)

  if (fetch) {
    cl <- InitCluster("github", "github-download.log", n=cluster.size)
    t <- system.time({
      clusterMap(cl, FetchGithubRepository, github$owner, github$repository,
                 MoreArgs=list(reposdir, update), SIMPLIFY=FALSE)
    })
    message(sprintf("%d repositories updated in %.3fs", nrow(github), t[3]))
    stopCluster(cl)
  }

  message("Making Github index")
  t <- system.time(index <- MakeGithubIndex(github, reposdir))
  message(sprintf("Github index made in %.3fs", t[3]))

  index
}

FilterGithubRepositories <- function(github, filter.only=FALSE, cluster.size) {
    message(sprintf("%d repositories to test", nrow(github)))
    cl <- InitCluster("github", "github-download.log", n=cluster.size)
    t <- system.time({
      res <- with(github, clusterMap(cl, TestGithubRepository, owner, repository, subdir,
                                     MoreArgs=list(filter.only=filter.only), SIMPLIFY=filter.only))
    })
    stopCluster(cl)
    res <- if (filter.only) github[res] else rbindlist(res)
    message(sprintf("repositories reduced to %s in %.3fs", nrow(github), t[3]))
    res
}

UpdateIndex <- function(datadir, db="rdata", host="mongodb://localhost",
                        cran.params=list(), github.params=list()) {
  cran.index <- do.call(CRANIndex, c(list(datadir), cran.params))
  github.index <- do.call(GithubIndex, c(list(datadir), github.params))
  index <- rbind(cran.index, github.index)
  con <- mongo("index", db, host)
  con$drop()
  loginfo("Adding %d rows to index on %s (%s)", nrow(index), db, host)
  con$insert(index)
}
