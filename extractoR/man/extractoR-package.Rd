\name{extractoR-package}
\alias{extractoR-package}
\alias{extractoR}
\docType{package}
\title{CRAN packages metadata extractor}
\description{
  extractoR is a set of R packages that can be used to fetch, extract
  and dump CRAN packages metadata. This main package acts as a glue for
  functions defined in other packages. Other packages are:
  extractoR.utils, extractoR.fetch, extractoR.extract, extractoR.query,
  extractoR.checkings, extractoR.content.
}

\details{
  extractoR is composed of the following packages:

  \code{extractoR.utils} placeholder for helper functions used across
  different packages.

  \code{extractoR.fetch} contains functions to fetch raw data from
  CRAN. Main functions are used to get the list of available packages,
  download these packages and extract them on local disk. Future
  versions will include mailing list fetching.

  \code{extractoR.extract} contains functions to read data extracted
  with extractoR.fetch and parse them. Most of those functions return
  \code{data.table} objects.

  \code{extractoR.checkings} contains functions to read and insert in
  SQL table results of "R CMD check" commands run on CRAN (see
  http://cran.r-project.org/web/checks/). It requires that one manually
  download the files check_flavors.rds, check_details.rds and
  check_results.rds and then store them in a directory which name is
  based on the date of extraction (using the format "%y-%m-%d-%H-%M").
  Ideally this manual extraction should be automated with a cron job to
  keep an history of this check results.

  \code{extractoR.content} browses packages and aggregates informations
  about packages content.
}

\author{
Maëlick Claes <himself@maelick.net>, Philippe Grosjean
<Philippe.Grosjean@umons.ac.be> & Prateek Rastogi
<p.rastogi@outlook.com>

Maintainer: Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{extract}

\examples{
\dontrun{
library(extractoR)

Fetch("data")
Extract("data")

rdata <- LoadRData("data/rds")
}
}