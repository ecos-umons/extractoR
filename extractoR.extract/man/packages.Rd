\name{Packages}
\alias{Packages}
\alias{FilterPackages}
\encoding{UTF-8}
\title{Packages}
\description{
  Identification of packages in CRAN and Github repositories
}

\usage{
Packages(index, descfiles, namespaces)
FilterPackages(packages)
}
\arguments{
  \item{index}{Repository index.}
  \item{descfiles}{DESCRIPTION \code{data.table} such as the one created
    by \code{Descfiles}.}
  \item{namespaces}{NAMESPACE \code{data.table} such as the one created
    by \code{Namespaces}.}
  \item{packages}{Package \code{data.table} such as the one returned by
    \code{FilterPackages}.}
}
\value{
  \code{Packages} returns a \code{data.table} with a list of
  repositories, package name and version (if any) and booleans checking
  whether DESCRIPTION and NAMESPACE files are well formatted.

  \code{FilterPackages} filters packages returned by \code{Packages} to
  only keep the valid ones.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{packages}
\keyword{extract}
