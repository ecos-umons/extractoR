pkglist.links <- function(url) {
  message(sprintf("Parsing %s", url))
  doc = htmlTreeParse(url, useInternalNodes=T)
  xpathSApply(doc, "//a[@href]", xmlValue)
}

pkglist.rversions <- function(links) {
  as.character(sapply(grep("^[0-9]+\\.[0-9]+.*/$", links, value=TRUE),
                      strsplit, "/"))
}

pkglist.archives <- function(links) {
  grep("\\.tar\\.gz$", links, value=TRUE)
}

pkglist.packages <- function(links) {
  as.character(sapply(grep("^[A-Za-z0-9].*/$", links, value=TRUE),
                      strsplit, "/"))
}

pkglist.recommended <- function(rversion) {
  url <- "http://cran.r-project.org/src/contrib/%s/Recommended"
  pkglist.archives(pkglist.links(sprintf(url, rversion)))
}

pkglist.archived <- function(package) {
  url <- "http://cran.r-project.org/src/contrib/Archive/%s"
  pkglist.archives(pkglist.links(sprintf(url, package)))
}

pkglist.archived.all <- function() {
  url <- "http://cran.r-project.org/src/contrib/Archive/"
  packages <- pkglist.packages(pkglist.links(url))
  as.vector(sapply(packages, pkglist.archived))
}

pkglist.cran <- function() {
  links <- pkglist.links("http://cran.r-project.org/src/contrib/")
  last <- pkglist.archives(links)
  rversions <- sapply(pkglist.rversions(links), pkglist.recommended)
  archived <- pkglist.archived.all()
  list(last=last, rversions=rversions, archived=archived)
}

pkglist.save <- function(packages, filename) {
  write(as.yaml(packages), file=filename)
}

pkglist.load <- function(filename) {
  yaml.load_file(filename)
}
