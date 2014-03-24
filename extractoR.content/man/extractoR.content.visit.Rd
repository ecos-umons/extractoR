\name{VisitPackages}
\alias{VisitPackages}
\encoding{UTF-8}
\title{VisitPackages}
\description{
  Visit CRAN packages content.
}

\usage{
VisitPackages(packages, pkgdir, FUNC, ..., simplify=TRUE)
}
\arguments{
  \item{packages}{A list of packages like the one returned by
    \code{FetchCRANList}}
  \item{pkgdir}{Directory where packages are stored.}
  \item{FUNC}{Functions that will be applied on each package. Takes the
    package name, version and path as parameters.}
  \item{...}{Additional parameters to pass to \code{FUNC}.}
  \item{simplify}{Whether to simplify the result or not (see
    \code{by}).}
}
\value{
  Returns all values of each call to \code{FUNC} (in a list if
  \code{simplify} is \code{FALSE}).
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{packages}
\keyword{visit}
