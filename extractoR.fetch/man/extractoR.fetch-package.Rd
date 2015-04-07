\name{extractoR.fetch-package}
\alias{extractoR.fetch-package}
\alias{extractoR.fetch}
\docType{package}
\encoding{UTF-8}
\title{CRAN packages metadata extractor (fetch)}
\description{
  extractoR.fetch is part of extractoR which is a set of R packages that
  can be used to fetch, extract and query CRAN packages
  metadata. extractoR.fetch parses CRAN web pages, downloads and
  extracts packages.
}

\author{
Maëlick Claes <himself@maelick.net> & Prateek Rastogi <p.rastogi@outlook.com>

Maintainer: Maëlick Claes <himself@maelick.net>
}
\keyword{fetch}
\keyword{cran}

\examples{
\dontrun{
library(extractoR.fetch)

mirror <- "http://cran.rstudio.com"

# Fetch the list of all recommended, contributed and archived packages
# on CRAN
cran <- FetchCRANList(mirror)
FetchPackage("A3", "0.9-1", "data/packages/")
FetchRVersions(mirror)
}
}
