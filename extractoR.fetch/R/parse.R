FetchPageLinks <- function(url) {
  message(sprintf("Parsing %s", url))
  doc = htmlTreeParse(url, useInternalNodes=T)
  xpathSApply(doc, "//a[@href]", xmlValue)
}

FetchRVersionsList <- function(links) {
  as.character(sapply(grep("^[0-9]+\\.[0-9]+.*/$", links, value=TRUE),
                      strsplit, "/"))
}

FetchArchivesList <- function(links) {
  grep("\\.tar\\.gz$", links, value=TRUE)
}

FetchPackagesList <- function(links) {
  as.character(sapply(grep("^[A-Za-z0-9].*/$", links, value=TRUE),
                      strsplit, "/"))
}

FetchRecommdedList <- function(rversion) {
  url <- "http://cran.r-project.org/src/contrib/%s/Recommended"
  FetchArchivesList(FetchPageLinks(sprintf(url, rversion)))
}

FetchArchivedList <- function(package) {
  url <- "http://cran.r-project.org/src/contrib/Archive/%s"
  FetchArchivesList(FetchPageLinks(sprintf(url, package)))
}

FetchAllArchivedList <- function() {
  url <- "http://cran.r-project.org/src/contrib/Archive/"
  packages <- FetchPackagesList(FetchPageLinks(url))
  as.vector(sapply(packages, FetchArchivedList))
}

FetchCRANList <- function() {
  links <- FetchPageLinks("http://cran.r-project.org/src/contrib/")
  last <- FetchArchivesList(links)
  rversions <- sapply(FetchRVersionsList(links), FetchRecommendedList)
  archived <- FetchAllArchivedList()
  list(last=last, rversions=rversions, archived=archived)
}

SavePackagesList <- function(packages, filename) {
  write(as.yaml(packages), file=filename)
}

LoadPackagesList <- function(filename) {
  yaml.load_file(filename)
}
