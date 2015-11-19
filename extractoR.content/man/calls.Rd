\name{Calls}
\alias{Calls}
\alias{ExplicitCalls}
\alias{ImplicitCalls}
\encoding{UTF-8}
\title{Calls}
\description{
  Resolve explicit and implicit calls.
}

\usage{
ExplicitCalls(source, repository, ref, datadir)
ImplicitCalls(source, repository, ref, datadir, deps.exports)
}
\arguments{
  \item{source}{Source of the repository.}
  \item{repository}{Repository in which the package is stored.}
  \item{ref}{Reference of the repository to use.}
  \item{datadir}{Directory where data is stored.}
  \item{deps.exports}{Exported function names of the package's depencies.}
}
\value{
  A \code{data.table} of function calls like the one returned by
  \code{FunctionCalls}.
}
\details{
  Explicit calls are the function calls declared directly using the
  \code{::} and \code{:::} notation with a package name.

  Implicit calls are all the other function calls found in the package
  for which an exported function was found in the NAMESPACE file of one
  of the dependencies.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{code}
\keyword{package}
\keyword{functions}
\keyword{calls}
