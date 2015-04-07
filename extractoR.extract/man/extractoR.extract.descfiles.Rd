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
ReadDescfile(package, version, filename)
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
  \code{ReadDescfiles} returns a four column \code{data.table} with packages
  name, version, DESCRIPTION files keys and values.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{description}
\keyword{descfile}
\keyword{extract}
