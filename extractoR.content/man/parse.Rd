\name{ParsePackage}
\alias{ParsePackage}
\encoding{UTF-8}
\title{ParsePackage}
\description{
  Parse a package R code.
}

\usage{
ParsePackage(package, version, path, fcode, fnull, ferr,
             guess.encoding=FALSE)
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
  \item{guess.encoding}{If TRUE try to guess file encoding. This might
    be useless and will drastically slow down the execution.}
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
