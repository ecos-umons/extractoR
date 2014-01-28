\name{Descfiles}
\alias{Descfiles}
\alias{ReadDescfiles}
\encoding{UTF-8}
\title{Descfiles}
\description{
  Extraction of DESCRIPTION files content
}

\usage{
ReadDescfiles(packages, datadir)
}
\arguments{
  \item{package}{A package name.}
  \item{datadir}{Directory where to store and extract the packages.}
}
\value{
  \code{ReadDescfiles} returns a four column dataframe with packages
  name, version, DESCRIPTION files keys and values.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{description}
\keyword{descfile}
\keyword{extract}
