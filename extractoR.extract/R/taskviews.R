ExtractTaskViews <- function(cran.mirror="http://cran.r-project.org") {
  # Returns a data frame listing the current task views.
  #
  # Returns:
  #   A five column dataframe containing the name of the taskview, its
  #   topic, its maintainer name and email, and its version.
  ctv <- CRAN.views(repos=cran.mirror)
  rbindlist(lapply(ctv, function(tv) {
    data.table(name=tv$name, topic=tv$topic, maintainers=tv$maintainer,
               email=tv$email, version=tv$version, repository=tv$repository,
               package=tv$packagelist$name, core=tv$packagelist$core)
  }))
}
