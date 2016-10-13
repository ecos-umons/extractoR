\name{Packages}
\alias{Packages}
\alias{FilterPackages}
\encoding{UTF-8}
\title{Packages}
\description{
  Identification of packages in CRAN and Github repositories
}

\usage{
Packages(index, descfile.con, namespace.con)
FilterPackages(packages)
}
\arguments{
  \item{index}{Repository index.}
  \item{descfile.con}{\code{mongolite} connection to descfile collection.}
  \item{namespace.con}{\code{mongolite} connection to namespace collection.}
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
