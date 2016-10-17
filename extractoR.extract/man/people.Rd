\name{People}
\alias{People}
\alias{Roles}
\encoding{UTF-8}
\title{People}
\description{
  Functions used to extract persons and roles from DESCRIPTION files.
}

\usage{
Roles(descfiles, role)
}
\arguments{
  \item{descfiles}{A \code{data.table} containing DESCRIPTION files (like the
    one returned by \code{ReadDescFiles}).}
  \item{role}{A role (either "Maintainer" or "Author").}
}
\value{
  Extracts all the people defined in DESCRIPTION files for a given role
  and returns a five columns \code{data.table} containing package name,
  version and the role, the name and email of people extracted.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{people}
\keyword{roles}
\keyword{extract}
