FetchPageLinks <- function(url) {
  # Fetches all links values from a web page.
  #
  # Args:
  #   url: The page's URL.
  #
  # Returns:
  #   The list of XML value of each links (i.e.content of the
  #   XPath expression "//a[@href]").
  message(sprintf("Parsing %s", url))
  doc = htmlTreeParse(url, useInternalNodes=T)
  xpathSApply(doc, "//a[@href]", xmlValue)
}

FetchRVersionsList <- function(links) {
  # Fetches the list of R's versions.
  #
  # Args:
  #   links: A list of links fetched by FetchPageLinks.
  #
  # Returns:
  #   The list of R's versions.
  as.character(sapply(grep("^[0-9]+\\.[0-9]+.*/$", links, value=TRUE),
                      strsplit, "/"))
}

FetchArchivesList <- function(links) {
  # Fetches a list of archives (.tar.gz files).
  #
  # Args:
  #   links: A list of links fetched by FetchPageLinks.
  #
  # Returns:
  #   The list of archives.
  grep("\\.tar\\.gz$", links, value=TRUE)
}

FetchPackagesList <- function(links) {
  # Fetches the list of packages.
  #
  # Args:
  #   links: A list of links fetched by FetchPageLinks.
  #
  # Returns:
  #   The list of packages.
  as.character(sapply(grep("^[A-Za-z0-9].*/$", links, value=TRUE),
                      strsplit, "/"))
}

FetchRecommdedList <- function(rversion,
                               cran.mirror="http://cran.r-project.org") {
  # Fetches the list of recommended package archives for a specific
  # R's version.
  #
  # Args:
  #   rversion: The R's version.
  #   cran.mirror: Root URL of the CRAN mirror to use.
  #
  # Returns:
  #   A list of package archives.
  url <- file.path(cran.mirror, "src/contrib/%s/Recommended")
  FetchArchivesList(FetchPageLinks(sprintf(url, rversion)))
}

FetchArchivedList <- function(package,
                              cran.mirror="http://cran.r-project.org") {
  # Fetches the list of archived archives of a given package.
  #
  # Args:
  #   package: The package to fetch the archived archives.
  #   cran.mirror: Root URL of the CRAN mirror to use.
  #
  # Returns:
  #   A list of archives that has been archived for the package.
  url <- file.path(cran.mirror, "src/contrib/Archive/%s")
  FetchArchivesList(FetchPageLinks(sprintf(url, package)))
}

FetchAllArchivedList <- function(cran.mirror="http://cran.r-project.org") {
  # Fetches the list of archived archives for all packages.
  #
  # Args:
  #   cran.mirror: Root URL of the CRAN mirror to use.
  #
  # Returns:
  #   The vector of all archives that has been archived.
  url <- file.path(cran.mirror, "src/contrib/Archive/")
  packages <- FetchPackagesList(FetchPageLinks(url))
  as.vector(sapply(packages, FetchArchivedList, cran.mirror))
}

FetchCRANList <- function(cran.mirror="http://cran.r-project.org") {
  # Fetches the list of all package archives (archived, non-archived
  # and recommded in all R's versions) of CRAN.
  #
  # Args:
  #   cran.mirror: Root URL of the CRAN mirror to use.
  #
  # Returns:
  #   A list containing the element last with all non-archived
  #   archives, rversions which is a list where each element is a
  #   vecotr containing all recommended archives for that R version
  #   and archived with all archived archives.
  links <- FetchPageLinks(file.path(cran.mirror, "src/contrib/"))
  last <- FetchArchivesList(links)
  rversions <- sapply(FetchRVersionsList(links),
                      FetchRecommdedList, cran.mirror)
  archived <- FetchAllArchivedList(cran.mirror)
  list(last=last, rversions=rversions, archived=archived)
}

SavePackagesList <- function(packages, filename) {
  # Saves a packages list to a YAML file.
  #
  # Args:
  #   packages: A list of package archives (like the one returned by
  #   FetchCRANList).
  #   filename: The file name of the YAML file.
  write(as.yaml(packages), file=filename)
}

LoadPackagesList <- function(filename) {
  # Loads a packages list from a YAML file.
  #
  # Args:
  #   filename: The file name of the YAML file.
  #
  # Returns:
  #   The loaded list of package archives (like the one returned by
  #   FetchCRANList).
  yaml.load_file(filename)
}
