\name{Dependencies}
\alias{ParseDependency}
\alias{ParseDependencies}
\alias{ExtractDependencies}
\encoding{UTF-8}
\title{ExtractDependencies}
\description{
  Extracts all the dependencies defined in DESCRIPTION files for a given
  dependency type.
}

\usage{
ParseDependency(string)
ParseDependencies(descfiles, keys, type.name=tolower(keys[1]))
ExtractDependencies(descfiles, types)
}
\arguments{
  \item{string}{A dependency string to parse}
  \item{descfiles}{A \code{data.table} containing DESCRIPTION files (like the
    one returned by \code{ReadDescFiles}).}
  \item{keys}{The types of dependencies to extract (either Depends,
    Imports, Suggests, Enhances or LinkingTo) as it appears in the
    DESCRIPTION file.}
  \item{type.name}{Name to give to the extracted dependency type.}
  \item{types}{List of dependency types whose values are \code{keys} and
    names are \code{type.name}.}
}
\value{
  \code{ExtractDependencies} returns a six columns \code{data.table}
  containing package name, version, the type of the dependency, the
  package in depends on (dependency), the constraint type
  (constraint.type) which is either >, >=, <, <=, == or nothing, and the
  constraint version (constraint.version) if any.

  \code{ParseDependencies} parses a dependency string into a three
  columns \code{data.table} with the dependency name and its constraint
  type and version if provided.

  \code{ExtractDependencies} extract all dependencies from
  \code{descfiles} that match \code{types}.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{dependencies}
\keyword{parse}
\keyword{extract}
