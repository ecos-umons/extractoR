GetDescfileName <- function(package, version, datadir) {
  file.path(datadir, package, version, package, "DESCRIPTION")
}

ReadDescfile <- function(package, version, datadir) {
  name <- GetDescfileName(package, version, datadir)
  if (file.exists(name)) {
    descfile <- read.dcf(name)
    n <- ncol(descfile)
    data.frame(package=rep(package, n), version=rep(version, n),
               key=colnames(descfile), value=as.vector(descfile[1, ]),
               stringsAsFactors=FALSE)
  } else NULL
}

ReadDescfiles <- function(packages, datadir) {
  descfiles <- apply(packages, 1,
                     function(p) ReadDescfile(p["package"], p["version"],
                                              datadir))
  dflist2df(descfiles, c("package", "version", "key", "value"))
}

GetDescfilesKeys <- function(descfiles) {
  unique(descfiles$key)
}

GetDescfilesKey <- function(descfiles, key) {
  descfiles[descfiles$key==key,]
}
