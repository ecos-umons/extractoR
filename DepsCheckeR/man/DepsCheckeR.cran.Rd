\name{CRANState}
\alias{CRANState}
\alias{GetCRANState}
\alias{GetCRANDeps}
\alias{GetCRANCheckings}
\encoding{UTF-8}
\title{CRANState}
\description{
  Functions used to read CRAN state from a SQL database.
}

\usage{
GetCRANState(con, flavor, date)
GetCRANDeps(con, flavor, date, types=c("depends", "imports"))
GetCRANCheckings(con, date, flavor=NULL)
}
\arguments{
  \item{con}{Connection object to the database.}
  \item{flavor}{The flavor to get the state.}
  \item{date}{The date of the state to get.}
  \item{types}{Types of dependencies to get (depends, imports, suggests
    and/or enhances).}
}
\value{
  \code{GetCRANState} returns the state of CRAN at a given date as a
  three column dataframe containing the package with their maintainer
  name and priority.

  \code{GetCRANDeps} returns all the package dependencies for a given
  CRAN state as a three-column dataframe containing all the depencencies
  from p1 to p2 and the dependency type.

  Returns the error checkings of CRAN (results of R CMD check) for a
  given date as a dataframe with the error checkings of CRAN containing
  on each row the name of the maintainer, the flavor name, the package
  name, the checking type, the checking status (ERROR, WARNING or NOTE)
  and the ouput.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{state}
