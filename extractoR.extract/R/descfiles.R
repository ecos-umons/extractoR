descfile.name <- function(package, version, datadir) {
  file.path(datadir, package, version, package, "DESCRIPTION")
}

descfile.read <- function(package, version, datadir) {
  name <- descfile.name(package, version, datadir)
  if(file.exists(name)) {
    descfile <- read.dcf(name)
    n <- ncol(descfile)
    data.frame(package=rep(package, n), version=rep(version, n),
               key=colnames(descfile), value=as.vector(descfile[1,]),
               stringsAsFactors=FALSE)
  } else NULL
}

descfiles.read <- function(packages, datadir) {
  descfiles <- apply(packages, 1,
                     function(p) descfile.read(p["package"], p["version"],
                                               datadir))
  dflist2df(descfiles, c("package", "version", "key", "value"))
}

descfiles.keys <- function(descfiles) {
  unique(descfiles$key)
}

descfiles.key <- function(descfiles, key) {
  m <- matrix(unlist(lapply(descfiles, function(d)d[d$key==key,])), nrow=4)
  data.frame(package=m[1,], version=m[1,], role=m[3,], people=m[4,])
}

descfiles.key <- function(descfiles, key) {
  descfiles[descfiles$key==key,]
}
