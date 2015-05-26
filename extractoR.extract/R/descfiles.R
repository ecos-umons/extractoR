DescfileName <- function(package, version, datadir) {
  # Returns the file name of a DESCRIPTION file.
  file.path(datadir, "packages", package, version, package, "DESCRIPTION")
}

ReadDescfile <- function(package, version, filename) {
  ## message(sprintf("Reading DESCRIPTION file %s", filename))
  if (file.exists(filename)) {
    descfile <- read.dcf(filename)
    values <- as.vector(descfile[1, ])
    encoding <- GuessEncoding(filename)
    if ("Encoding" %in% colnames(descfile)) {
      encoding <- descfile[colnames(descfile) == "Encoding"]
    }
    values <- iconv(as.vector(descfile[1, ]), encoding, "utf8")
    n <- ncol(descfile)
    as.data.table(list(package=package, version=version,
                       key=colnames(descfile), value=values))
  } else NULL
}

CRANDescfiles <- function(cran, datadir) {
  cran <- unique(cran[, list(package, version)])
  packages <- cran$package
  versions <- cran$version
  filenames <- mapply(DescfileName, packages, versions,
                      MoreArgs=list(datadir), SIMPLIFY=FALSE)
  rbindlist(mapply(ReadDescfile, packages, versions, filenames, SIMPLIFY=FALSE))
}
