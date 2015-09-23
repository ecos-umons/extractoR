\name{Index}
\alias{Index}
\alias{SnapshotIndex}
\alias{CRANCheckHistory}
\alias{FlavorHistory}
\encoding{UTF-8}
\title{Index}
\description{
  Functions used to read R CMD check informations.
}

\usage{
SnapshotIndex(datadir, Subset, remove.duplicates)
CRANCheckHistory(datadir, flavors, filename, remove.duplicates)
FlavorHistory(datadir, remove.duplicates)
}
\arguments{
  \item{datadir}{Root directory where data is stored.}
  \item{Subset}{Function taking a snapshot as parameter.}
  \item{remove.duplicates}{If TRUE only keep one snapshot per date.}
  \item{flavors}{Flavors to select.}
  \item{filename}{Name of the CSV file to save result in.}
}

\value{
  \code{SnapshotIndex} builds an index of CRAN snapshots from CSV
  converted checking results. Subset is a function used to select a
  subset of each snapshot to return.

  \code{CRANCheckHistory} returns the history of CRAN check results for
  a selected flavors.

  \code{flv} returns the history of available flavors.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{check}
\keyword{status}
\keyword{R CMD check}
