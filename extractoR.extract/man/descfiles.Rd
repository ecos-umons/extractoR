\name{Descfiles}
\alias{Descfiles}
\alias{ReadDescfile}
\alias{ReadCRANDescfile}
\alias{ReadGithubDescfile}
\encoding{UTF-8}
\title{Descfiles}
\description{
  Extraction of DESCRIPTION files content
}

\usage{
ReadDescfile(filename, package=NA, version=NA)
ReadCRANDescfile(package, version, datadir)
ReadGithubDescfile(package, ref, datadir)
Descfiles(index, datadir)
}
\arguments{
  \item{package}{Package name}
  \item{version}{Version of package}
  \item{filename}{Filename of the DESCRIPTION file}
  \item{ref}{Git repository reference (commit, branch or tag).}
  \item{index}{Repository index.}
  \item{datadir}{Directory where to store and extract the packages.}
}
\value{
  \code{ReadDescfiles} returns a two or four column \code{data.table}
  with packages DESCRIPTION files keys and values, and package name and
  version given as parameters.

  \code{ReadCRANDescfiles} reads DESCRIPTION file of a CRAN package.

  \code{ReadGithubDescfiles} reads DESCRIPTION file of a Github R
  package.

  \code{Descfiles} reads the DESCRIPTION file of all packages of
  \code{index}.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{description}
\keyword{descfile}
\keyword{extract}
