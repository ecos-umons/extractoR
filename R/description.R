descfilename <- function(package, version, datadir) {
  paste(datadir, package, version, package, "DESCRIPTION", sep="/")
}

read.descfile <- function(package, version, datadir) {
  as.list(read.dcf(get.descfile(package, version, datadir))[1,])
}
