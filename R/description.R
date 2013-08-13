descfilename <- function(version, package, datadir) {
  paste(datadir, package, version, package, "DESCRIPTION", sep="/")
}

read.descfile <- function(version, package, datadir) {
  as.list(read.dcf(descfilename(version, package, datadir))[1,])
}

read.package <- function(package, datadir) {
  res <- lapply(package$versions, read.descfile, package$name, datadir)
  names(res) <- package$versions
  res
}

read.descfiles <- function(packages, datadir) {
  sapply(packages, read.package, datadir)
}
