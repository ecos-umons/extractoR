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

has.key <- function(descfile, key) {
  key %in% names(descfile)
}

packages.with.key <- function(key, descfiles) {
  sapply(descfiles, function(p)p[sapply(p, has.key, key)])
}

num.packages.with.keyw <- function(key, descfiles) {
  sum(sapply(packages.with.key(key, descfiles), length))
}

all.keys <- function(descfiles) {
  unique(c(sapply(descfiles, function(p)unique(c(sapply(p, names),
                                                 recursive=TRUE))),
           recursive=TRUE))
}

num.packages.all.keys <- function(descfiles) {
  sapply(all.keys(descfiles), num.packages.with.key, descfiles)
}
