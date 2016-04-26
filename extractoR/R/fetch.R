CRANFetch <- function(datadir, cran.mirror="http://cran.r-project.org") {
  rdata <- list()

  datadir <- file.path(datadir, "cran")

  message("Fetching CRAN list")
  t <- system.time(rdata$packages <- FetchCRANList(cran.mirror))
  message(sprintf("Package list fetched from CRAN in %.3fs", t[3]))

  message("Fetching R Versions")
  t <- system.time(rdata$rversions <- FetchRVersions(cran.mirror))
  message(sprintf("R versions list fetched from CRAN in %.3fs", t[3]))

  rdata$index <- MakeCRANIndex(rdata$packages)

  message("Saving objects in data/cran/rds")
  t <- system.time({
    SaveRData(rdata, datadir)
    SaveCSV(rdata, datadir)
  })
  message(sprintf("Objects saved in %.3fs", t[3]))

  message("Downloading missing packages")
  cran <- rdata$packages
  t <- system.time(res <- mapply(FetchPackage, cran$package, cran$version,
                                 file.path(datadir, "packages"), cran.mirror))
  message(sprintf("%d packages downloaded in %.3fs", length(res[res]), t[3]))
}

GithubFetch <- function(datadir, fetch=TRUE, update=TRUE, cluster.size=4,
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

  rdata <- list(repositories=github)

  message("Makeing Github index")
  t <- system.time(rdata$index <- MakeGithubIndex(github, reposdir, ignore))
  message(sprintf("Github index made in %.3fs", t[3]))

  message("Fetching Github repositories tags")
  t <- system.time(rdata$tags <- RepositoryTags(github, reposdir))
  message(sprintf("Github repositories tags fetched in %.3fs", t[3]))

  message("Saving objects in data/github/rds")
  t <- system.time({
    SaveRData(rdata, datadir)
    SaveCSV(rdata, datadir)
  })
  message(sprintf("Objects saved in %.3fs", t[3]))
}
