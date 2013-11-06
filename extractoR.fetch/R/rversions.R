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

FetchRecommendedList <- function(rversion,
                               cran.mirror="http://cran.r-project.org") {
  # Fetches the list of recommended package archives for a specific
  # R's version.
  url <- file.path(cran.mirror, "src/contrib/%s/Recommended")
  packages <- FetchArchivesList(FetchPageLinks(sprintf(url, rversion)))
  res <- data.frame(filename=packages, size=NA, mtime=NA,
                    stringsAsFactors=FALSE)
  res$rversion <- rversion
  res
}

FetchRVersions <- function(cran.mirror="http://cran.r-project.org") {
  links <- FetchPageLinks(file.path(cran.mirror, "src/contrib/"))
  res <- lapply(FetchRVersionsList(links), FetchRecommendedList, cran.mirror)
  dflist2df(res)
}
