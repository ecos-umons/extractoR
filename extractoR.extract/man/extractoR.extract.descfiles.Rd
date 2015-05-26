\name{Descfiles}
\alias{Descfiles}
\alias{CRANDescfiles}
\alias{ReadDescfile}
\encoding{UTF-8}
\title{Descfiles}
\description{
  Extraction of DESCRIPTION files content
}

\usage{
ReadDescfile(filename, package=NA, version=NA)
CRANDescfiles(cran, datadir)
}
\arguments{
  \item{package}{Package name}
  \item{version}{Version of package}
  \item{filename}{Filename of the DESCRIPTION file}
  \item{cran}{A list of packages like the one returned by
    \code{FetchCRANList}}
  \item{datadir}{Directory where to store and extract the packages.}
}
\value{
  \code{ReadDescfiles} returns a two or four column \code{data.table}
  with packages DESCRIPTION files keys and values, and package name and
  version given as parameters.

  \code{CRANDescfiles}
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{description}
\keyword{descfile}
\keyword{extract}
