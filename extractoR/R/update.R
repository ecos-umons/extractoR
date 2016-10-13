CRANIndex <- function(datadir, cran.mirror="http://cran.r-project.org") {
  datadir <- file.path(datadir, "cran")

  message("Fetching CRAN list")
  t <- system.time(packages <- FetchCRANList(cran.mirror))
  message(sprintf("Package list fetched from CRAN in %.3fs", t[3]))

  index <- MakeCRANIndex(packages)

  message("Downloading missing packages")
  t <- system.time(res <- mapply(FetchPackage, index$package, index$version,
                                 file.path(datadir, "packages"), cran.mirror))
  message(sprintf("%d packages downloaded in %.3fs", length(res[res]), t[3]))

  index
}

GithubIndex <- function(datadir, fetch=TRUE, update=TRUE, cluster.size=4,
                        ignore=c("cran", "rpkg", "Bioconductor-mirror")) {
  datadir <- file.path(datadir, "github")
  reposdir <- file.path(datadir, "repos")
  github <- as.data.table(read.csv(file.path(datadir, "csv/repositories.csv"),
                                   stringsAsFactors=FALSE))
  if (!"subdir" %in% names(github)) {
    github[, subdir := "."]
  }
  if (!"owner" %in% names(github)) {
    setnames(github, c("name", "owner.login"), c("repository", "owner"))
  }

  cl <- InitCluster("github", "github-download.log", n=cluster.size)
  t <- system.time({
    exist <- clusterMap(cl, TestGithubRepository,
                        github$owner, github$repository,
                        github$subdir, SIMPLIFY=TRUE)
  })
  message(sprintf("%d repositories tested in %.3fs", nrow(github), t[3]))
  github <- github[exist]
  message(sprintf("repositories reduced to %s", nrow(github), t[3]))
  stopCluster(cl)

  if (fetch) {
    cl <- InitCluster("github", "github-download.log", n=cluster.size)
    t <- system.time({
      clusterMap(cl, FetchGithubRepository, github$owner, github$repository,
                 MoreArgs=list(reposdir, update), SIMPLIFY=FALSE)
    })
    message(sprintf("%d repositories updated in %.3fs", nrow(github), t[3]))
    stopCluster(cl)
  }

  # FIXME
  ## message("Fetching Github repositories tags")
  ## t <- system.time(rdata$tags <- RepositoryTags(github, reposdir))
  ## message(sprintf("Github repositories tags fetched in %.3fs", t[3]))

  message("Making Github index")
  t <- system.time(index <- MakeGithubIndex(github, reposdir, ignore))
  message(sprintf("Github index made in %.3fs", t[3]))

  index
}

UpdateIndex <- function(db="rdata", host="mongodb://localhost", datadir,
                        cran.params=list(), github.params=list()) {
  cran.index <- do.call(CRANIndex, c(list(datadir), cran.params))
  github.index <- do.call(CRANIndex, c(list(datadir), github.params))
  loginfo("Adding %d rows to index on %s (%s)", nrow(index), db, host)
  con <- mongo("index", db, host)
  index <- MissingEntries(rbind(cran.index, github.index), con)
  con$insert(index)
}
