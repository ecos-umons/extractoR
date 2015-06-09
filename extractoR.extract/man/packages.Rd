\name{Packages}
\alias{Packages}
\encoding{UTF-8}
\title{Packages}
\description{
  Identification of packages in CRAN repositories
}

\usage{
Packages(descfiles, broken)
}
\arguments{
  \item{descfiles}{DESCRIPTION files table.}
  \item{broken}{Broken packages table.}
}
\value{
  A \code{data.table} with a list of repositories and their associated
  package metadata.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{packages}
\keyword{extract}
