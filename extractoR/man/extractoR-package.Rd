\name{extractoR-package}
\alias{extractoR-package}
\alias{extractoR}
\docType{package}
\title{CRAN packages metadata extractor}
\description{
  extractoR is a set of R packages that can be used to fetch, extract
  and dump CRAN packages metadata. This main package acts as a glue for
  functions defined in other packages. Other packages are:
  extractoR.utils, extractoR.fetch, extractoR.extract, extractoR.query.
}

\details{
  extractoR is composed of the following packages:
  \item{extractoR.utils}{Placeholder for helper functions used across
    different packages.}
  \item{extractoR.fetch}{Contains functions to fetch raw data from
    CRAN. Main functions are used to get the list of available packages,
    download these packages and extract them on local disk. Future
    versions will include mailing list fetching.}
  \item{extractoR.extract}{Contains functions to read data extracted
    with extractoR.fetch and parse them.. Most of those functions return
    data frames.}
  \item{extractoR.sql}{Contains functions related to SQL database. Its
    main purpose is to store dataframes created by extractoR.extract
    into SQL tables.}
}
\tabular{ll}{
Package: \tab extractoR\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2013-08-21\cr
License: \tab GPL-3\cr
}
An overview of how to use the package, including the most important functions
}

\author{
Maëlick Claes <himself@maelick.net>, Philippe Grosjean
<Philippe.Grosjean@umons.ac.be> & Prateek Rastogi
<p.rastogi@outlook.com>

Maintainer: Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{extract}

\seealso{
  While not being part of extractoR itself, another related package is
  DepsCheckeR which reads results of "R CMD check" commands run by CRAN
  (see http://cran.r-project.org/web/checks/). It is not part of
  extractoR because it requires that one manually download the files
  check_flavors.rds, check_details.rds and check_results.rds and then
  store them in a directory which name is based on the date of
  extraction (using the format "%y-%m-%d-%H-%M"). Ideally this manual
  extraction should be automated with a cron job to keep an history of
  this check results. The package contains also functions to analyse
  dependencies of CRAN packages and see how they evolve over time.
}
