\name{Dependencies}
\alias{Dependencies}
\alias{ExtractDependencies}
\encoding{UTF-8}
\title{Dependencies}
\description{
  Extracts all the dependencies defined in DESCRIPTION files for a given
  dependency type.
}

\usage{
Dependencies(descfiles, types)
ExtractDependencies(db="rdata", host="mongodb://localhost")
}
\arguments{
  \item{descfiles}{A \code{data.table} containing DESCRIPTION files (like the
    one returned by \code{ReadDescFiles}).}
  \item{types}{List of dependency types whose values are \code{keys} and
    names are \code{type.name}.}
  \item{db}{MongoDB database.}
  \item{host}{MongoDB host.}
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

  \code{ExtractDependencies} extracts all dependencies missing in MongoDB.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{dependencies}
\keyword{parse}
\keyword{extract}
