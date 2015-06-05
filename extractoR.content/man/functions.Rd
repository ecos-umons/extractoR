\name{BrowseFunctions}
\alias{BrowseFunctions}
\encoding{UTF-8}
\title{BrowseFunctions}
\description{
  Browse CRAN packages functions with CloneR.
}

\usage{
BrowseFunctions(packages, pkg.dir, func.dir, log.dir=NULL)
}
\arguments{
  \item{packages}{A list of packages like the one returned by
    \code{FetchCRANList}}
  \item{pkg.dir}{Directory where packages are stored.}
  \item{func.dir}{Directory where result will be stored in RDS files.}
  \item{log.dir}{Directory where error output will be stored (in RDS
    files) when code parsing fails. If NULL the output won't be stored.}
}
\value{
  Runs on all packages CloneR \code{FindFunctions}. Stores the result of
  each package in one RDS file named package_version.rds or the error
  output if parsing failed. Do not parse package for which a RDS file
  exists in \code{func.dir} and \code{log.dir}.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{packages}
\keyword{visit}
