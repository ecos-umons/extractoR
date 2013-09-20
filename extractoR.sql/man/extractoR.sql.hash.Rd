\name{Hash}
\alias{Hash}
\alias{GetHashPackages}
\alias{GetHashVersions}
\alias{GetHashPeople}
\alias{GetHashDependencies}
\alias{GetHashTaskViews}
\alias{GetHashTaskViewVersion}
\alias{GetVersionKey}
\alias{GetPersonKey}
\alias{GetDependencyKey}
\alias{GetTaskViewVersionKey}
\encoding{UTF-8}
\title{Hash}
\description{
  Functions used to use hash tables to store tables ids.
}

\usage{
GetHashPackages(con)
GetHashVersions(con)
GetHashPeople(con)
GetHashDependencies(con)
GetHashTaskViews(con)
GetHashTaskViewVersion(con)

GetVersionKey(version)
GetPersonKey(person)
GetDependencyKey(dependency)
GetTaskViewVersionKey(taskview)
}

\arguments{
  \item{con}{Connection object to the database.}
  \item{version}{Vector containing a package name and version.}
  \item{person}{Vector containing a person name and email}
  \item{dependency}{Vector containing a package name, version, a
    dependency type and a dependency package name.}
  \item{taskview}{Vector containing a taskview name and version}
}
\value{
  \code{Get*Hash} functions hash related to the SQL table.

  \code{Get*Key} is used to get a string key for the hash table for
  tables having more than one column for the unique index.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{parse}
\keyword{archive}
\keyword{name}
\keyword{package}