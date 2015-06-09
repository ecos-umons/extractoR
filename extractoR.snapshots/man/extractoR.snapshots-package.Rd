\name{extractoR.snapshots-package}
\alias{extractoR.snapshots-package}
\alias{extractoR.snapshots}
\docType{package}
\encoding{UTF-8}
\title{CRAN snapshots extraction}
\description{
  This package contains functions to read results of "R CMD check"
  commands run on CRAN (see http://cran.r-project.org/web/checks/). It
  requires that one manually download the files check_flavors.rds,
  check_details.rds and check_results.rds and then store them in a
  directory which name is based on the date of extraction (using the
  format "%y-%m-%d-%H-%M"). Ideally this manual extraction should be
  automated with a cron job to keep an history of this check results.
}

\author{
Maëlick Claes <himself@maelick.net>

Maintainer: Maëlick Claes <himself@maelick.net>
}

\keyword{check}
\keyword{snapshot}
\keyword{cran}
\keyword{errors}
\keyword{R CMD check}