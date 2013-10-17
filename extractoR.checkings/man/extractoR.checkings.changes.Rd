\name{CRANChanges}
\alias{CRANChanges}
\alias{ExtractChanges}
\alias{InsertChanges}
\encoding{UTF-8}
\title{CRANChanges}
\description{
  Functions used to extract and insert into a database CRAN Changes
  which are the diffs between consecutive CRAN Status.
}

\usage{
ExtractChanges(con, flavor)
InsertChanges(con, flavor, changes)
}
\arguments{
  \item{con}{Connection object to the database.}
  \item{flavor}{Flavor name.}
  \item{changes}{Changes dataframe.}
}
\details{
  \code{InsertChanges} inserts changes extracted into a database.

  \code{ExtractChanges} extracts changes from CRAN Status (stored in a
  database) and for a specific flavor.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{insert}
\keyword{sql}
