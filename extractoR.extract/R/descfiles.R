DescfileName <- function(package, version, datadir) {
  # Returns the file name of a DESCRIPTION file.
  file.path(datadir, "packages", package, version, package, "DESCRIPTION")
}

ReadDescfile <- function(filename, package=NA, version=NA) {
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
    res <- as.data.table(key=colnames(descfile), value=values)
    if (is.na(package) | is.na(version)) res
    else cbind(data.table(package=package, version=version), res)
  } else NULL
}

CRANDescfiles <- function(cran, datadir) {
  cran <- unique(cran[, list(package, version)])
  packages <- cran$package
  versions <- cran$version
  filenames <- mapply(DescfileName, packages, versions,
                      MoreArgs=list(datadir), SIMPLIFY=FALSE)
  rbindlist(mapply(ReadDescfile, filenames, packages, versions, SIMPLIFY=FALSE))
}

IsPackage <- function(descfile) {
  descfile[, "Package" %in% key && "Version" %in% key]
}

IsBroken <- function(descfile) {
  !IsPackage(descfile) || !DepsWellFormatted(descfile)
}

BrokenPackages <- function(descfiles) {
  res <- descfiles[, list(is.package=IsPackage(.SD),
                          deps.well.formatted=DepsWellFormatted(.SD)),
                   by=c("package", "version")]
  res[, is.broken := !is.package | !deps.well.formatted]
}
