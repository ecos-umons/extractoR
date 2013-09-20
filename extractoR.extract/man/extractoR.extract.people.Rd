\name{People}
\alias{People}
\alias{ExtractPerson}
\alias{ExtractRoles}
\alias{ExtractPeople}
\encoding{UTF-8}
\title{People}
\description{
  Functions used to extract persons and roles from DESCRIPTION files.
}

\usage{
ExtractPerson(s)
ExtractRoles(descfiles, role)
ExtractPeople(roles)
}
\arguments{
  \item{s}{A string containing authors or maintainers.}
  \item{descfiles}{A dataframe containing DESCRIPTION files (like the
    one returned by ReadDescFiles).}
  \item{role}{A role (either "Maintainer" or "Author").}
  \item{roles}{A dataframe like the one returned by ExtractRoles.}
}
\value{
  \code{ExtractPerson} extracts all the people defined in a string and
  returns a two columns dataframe containing the name and email of
  people extracted.

  \code{ExtractRoles} extracts all the people defined in DESCRIPTION
  files for a given role and returns a five columns dataframe containing
  package name, version and the role, the name and email of people
  extracted.

  \code{ExtractPeople} Returns the list of all different people
  contained in a roles dataframe and returns a two-column dataframe
  containing the people names and emails.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{people}
\keyword{roles}
\keyword{extract}
