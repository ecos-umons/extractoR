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

FetchRVersions <- function(cran.mirror="http://cran.r-project.org") {
  links <- FetchPageLinks(file.path(cran.mirror, "src/contrib/"))
  sapply(FetchRVersionsList(links), FetchRecommdedList, cran.mirror)
}
