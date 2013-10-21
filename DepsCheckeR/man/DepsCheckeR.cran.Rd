\name{CRANState}
\alias{CRANState}
\alias{GetCRANStatus}
\alias{GetCRANDeps}
\alias{GetCRANChanges}
\encoding{UTF-8}
\title{CRANState}
\description{
  Functions used to read CRAN state from a SQL database.
}

\usage{
GetCRANState(con, flavor, date)
GetCRANDeps(con, flavor, date, types=c("depends", "imports"))
GetCRANChanges(con, date, flavor=NULL)
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
  name, priority and status (ERROR, WARNING, NOTE or OK).

  \code{GetCRANDeps} returns all the package dependencies for a given
  CRAN state as a three-column dataframe containing all the depencencies
  from p1 to p2 and the dependency type.

  \code{GetCRANChanges} returns the changes of status of CRAN (results
  of R CMD check) for a given date as a dataframe containing on each row
  the name of the maintainer, the flavor name, the package name, the
  change type and the old and new values.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{state}
