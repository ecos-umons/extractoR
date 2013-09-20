\name{ExtractDependencies}
\alias{ExtractDependencies}
\encoding{UTF-8}
\title{ExtractDependencies}
\description{
  Extracts all the dependencies defined in DESCRIPTION files for a given
  dependency type.
}

\usage{
ExtractDependencies(descfiles, type)
}
\arguments{
  \item{descfiles}{A dataframe containing DESCRIPTION files (like the
    one returned by ReadDescFiles).}
  \item{role}{A type of dependency (either "Depends", "Imports",
    "Suggests" or "Enhances").}
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

\keyword{parse}
\keyword{archive}
\keyword{name}
\keyword{package}