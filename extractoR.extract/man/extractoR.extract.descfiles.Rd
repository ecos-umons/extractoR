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
BrokenPackages(descfiles)
}
\arguments{
  \item{package}{Package name}
  \item{version}{Version of package}
  \item{filename}{Filename of the DESCRIPTION file}
  \item{cran}{A list of packages like the one returned by
    \code{FetchCRANList}}
  \item{datadir}{Directory where to store and extract the packages.}
  \item{descfiles}{DESCRIPTION files}
}
\value{
  \code{ReadDescfiles} returns a two or four column \code{data.table}
  with packages DESCRIPTION files keys and values, and package name and
  version given as parameters.

  \code{CRANDescfiles} reads DESCRIPTION files of all CRAN packages and
  returns a single \code{data.table}.

  \code{BrokenPackages} returns a \code{data.table} telling which
  packages are not packages (does not contain a "Package" and "Version"
  entry in DESCRIPTION file) and have not well formatted dependencies.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{description}
\keyword{descfile}
\keyword{extract}
