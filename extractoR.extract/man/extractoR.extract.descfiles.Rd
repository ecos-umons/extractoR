\name{Descfiles}
\alias{Descfiles}
\alias{ReadDescfile}
\alias{ReadDescfiles}
\alias{GetDescfilesKeys}
\alias{GetDescfilesKey}
\encoding{UTF-8}
\title{Descfiles}
\description{
  Functions used to extract and manipulate packages DESCRIPTION files.
}

\usage{
ReadDescfile(package, version, datadir)
ReadDescfiles(packages, datadir)
GetDescfilesKeys(descfiles)
GetDescfilesKey(descfiles, key)
}
\arguments{
  \item{package}{A package name.}
  \item{version}{A package version.}
  \item{packages}{A list of packages like the one returned by
    \code{FetchCRANList}}
  \item{datadir}{Directory where to store and extract the packages.}
  \item{descfiles}{A dataframe containing DESCRIPTION files (like the
    one returned by ReadDescFiles).}
  \item{key}{A DESCRIPTION file key.}
}
\value{
  \code{ReadDescfile} and {ReadDescfiles} returns a four column
  dataframe with packages name, version, DESCRIPTION files keys and
  values.

  \code{GetDescfilesKey} returns the set of all keys contained in
  DESCRIPTION files.

  \code{GetDescfilesKey} returns the values for a given key.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{description}
\keyword{descfile}
\keyword{extract}
