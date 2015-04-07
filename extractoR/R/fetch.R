Fetch <- function(datadir, cran.mirror="http://cran.r-project.org") {
  message("Fetching CRAN list")
  t <- system.time(cran <- FetchCRANList(cran.mirror))
  saveRDS(cran, file.path(datadir, "rds", "packages.rds"))
  message(sprintf("CRAN list fetched from CRAN in %.3fs", t[3]))

  message("Fetching R Versions")
  t <- system.time(rversions <- FetchRVersions(cran.mirror))
  saveRDS(rversions, file.path(datadir, "rds", "rversions.rds"))
  message(sprintf("CRAN list fetched from CRAN in %.3fs", t[3]))

  message("Downloading missing packages")
  t <- system.time(res <- mapply(FetchPackage, cran$package, cran$version,
                                 datadir, cran.mirror))
  message(sprintf("%d packages downloaded in %.3fs", length(res[res]), t[3]))
}
