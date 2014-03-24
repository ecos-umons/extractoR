GetDescfileName <- function(package, version, datadir) {
  # Returns the file name of a DESCRIPTION file.
  file.path(datadir, package, version, package, "DESCRIPTION")
}

ReadDescfile <- function(package, version, datadir) {
  message(sprintf("Reading DESCRIPTION file %s %s", package, version))
  name <- GetDescfileName(package, version, datadir)
  if (file.exists(name)) {
    descfile <- read.dcf(name)
    values <- as.vector(descfile[1, ])
    encoding <- GuessEncoding(name)
    if ("Encoding" %in% colnames(descfile)) {
      encoding <- descfile[colnames(descfile) == "Encoding"]
    }
    values <- iconv(as.vector(descfile[1, ]), encoding, "utf8")
    n <- ncol(descfile)
    data.frame(package=rep(package, n), version=rep(version, n),
               key=colnames(descfile), value=values, stringsAsFactors=FALSE)
  } else NULL
}

ExtractDescfiles <- function(packages, datadir) {
  descfiles <- apply(packages, 1,
                     function(p) ReadDescfile(p["package"], p["version"],
                                              datadir))
  FlattenDF(descfiles)
}
