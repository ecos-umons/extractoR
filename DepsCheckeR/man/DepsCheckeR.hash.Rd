\name{Hash}
\alias{Hash}
\alias{GetHashFlavors}
\alias{GetHashCRANStatus}
\alias{GetCRANStatusKey}
\encoding{UTF-8}
\title{Hash}
\description{
  Functions used to use hash tables to store tables ids.
}

\usage{
GetHashFlavors(con)
GetHashCRANStatus(con, date)

GetCRANStatusKey(status)
}

\arguments{
  \item{con}{Connection object to the database.}
  \item{date}{Date of the status to get}
  \item{status}{Vector containing a status package, version, flavor and
    date.}
}
\value{
  \code{Get*Hash} functions hash related to the SQL table.

  \code{Get*Key} is used to get a string key for the hash table for
  tables having more than one column for the unique index.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{hash}
\keyword{key}
