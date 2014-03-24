\name{ParsePackage}
\alias{ParsePackage}
\encoding{UTF-8}
\title{ParsePackage}
\description{
  Parse a package R code.
}

\usage{
ParsePackage(package, version, path, fcode, fnull, ferr)
}
\arguments{
  \item{package}{Name of the package.}
  \item{version}{Version of the package.}
  \item{path}{Path where the package is stored}
  \item{fcode}{Function to call when package code was successfull
    parsed.}
  \item{fnull}{Function to call when package doesn't contain code.}
  \item{ferr}{Function to call when package code parsing produced an
    error.}
}
\value{
  Returns the value that fcode, fnull or ferr produced depending on
  which one has been called.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{description}
\keyword{descfile}
\keyword{extract}
