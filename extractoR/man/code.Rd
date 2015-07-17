\name{Code}
\alias{Code}
\alias{ParseCode}
\alias{ExtractFunctions}
\alias{ExtractFunctionCalls}
\alias{ExtractCodingStyle}
\encoding{UTF-8}
\title{Code}
\description{
  Extract informations from packages R code with sourceR.
}

\usage{
ParseCode(datadir)
ExtractFunctions(datadir, cluster.size=6)
ExtractFunctionCalls(datadir, cluster.size=6)
ExtractCodingStyle(datadir, cluster.size=6)
}
\arguments{
  \item{datadir}{Directory where data is stored.}
  \item{cluster.size}{Number of cluster nodes to use.}
}
\value{
  \code{ParsePackage} parses package code and stores result in
  rds files.

  \code{ExtractFunctions}, \code{ExtractFunctionCalls} and
  \code{ExtractCodingStyle} extract function definitions, function calls
  and coding style found inside R packages and store them on disk. These
  functions are run on a cluster of the given size.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{code}
\keyword{package}
\keyword{functions}
\keyword{calls}
\keyword{style}
