\name{People}
\alias{People}
\alias{ExtractRoles}
\alias{ExtractPeople}
\encoding{UTF-8}
\title{People}
\description{
  Functions used to extract persons and roles from DESCRIPTION files.
}

\usage{
ExtractPeople(s)
ExtractRoles(descfiles, role)
}
\arguments{
  \item{s}{A string containing authors or maintainers.}
  \item{descfiles}{A \code{data.table} containing DESCRIPTION files (like the
    one returned by \code{ReadDescFiles}).}
  \item{role}{A role (either "Maintainer" or "Author").}
}
\value{
  \code{ExtractPeople} extracts all the people defined in a string and
  returns a two columns \code{data.table} containing the name and email of
  people extracted.

  \code{ExtractRoles} extracts all the people defined in DESCRIPTION
  files for a given role and returns a five columns \code{data.table} containing
  package name, version and the role, the name and email of people
  extracted.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{people}
\keyword{roles}
\keyword{extract}
