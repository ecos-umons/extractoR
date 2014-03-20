\name{ExtractDependencies}
\alias{ExtractDependencies}
\encoding{UTF-8}
\title{ExtractDependencies}
\description{
  Extracts all the dependencies defined in DESCRIPTION files for a given
  dependency type.
}

\usage{
ExtractDependencies(descfiles, types, type.name=tolower(type[1]))
}
\arguments{
  \item{descfiles}{A dataframe containing DESCRIPTION files (like the
    one returned by ReadDescFiles).}
  \item{types}{The type of dependency to extract (either Depends,
    Imports, Suggests, Enhances or LinkingTo) as it appears in the
    DESCRIPTION file.}
  \item{type}{Name to give to the extracted dependency type.}
}
\value{
  A six columns dataframe containing package name, version, the type of
  the dependency, the package in depends on (dependency), the constraint
  type (constraint.type) which is either >, >=, <, <=, == or nothing,
  and the constraint version (constraint.version) if any.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{dependencies}
\keyword{extract}
