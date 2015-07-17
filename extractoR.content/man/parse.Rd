\name{ParsePackage}
\alias{ParsePackage}
\encoding{UTF-8}
\title{ParsePackage}
\description{
  Parse a package R code.
}

\usage{
ParsePackage(source, repository, ref, datadir)
}
\arguments{
  \item{source}{Source of the repository.}
  \item{repository}{Repository in which the package is stored.}
  \item{ref}{Reference of the repository to use.}
  \item{datadir}{Directory where data is stored.}
}
\value{
  Parse the R code of the package found in the given repository into
  \code{datadir}/code/\code{source}/\code{repository}/\code{ref}.rds.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{package}
\keyword{code}
\keyword{parse}
