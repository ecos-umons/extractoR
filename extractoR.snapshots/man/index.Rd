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
SnapshotIndex(datadir, Subset, remove.duplicates=FALSE)
CRANCheckHistory(datadir, flv="r-release-linux-x86_64", remove.duplicates=FALSE)
FlavorHistory(datadir, remove.duplicates=FALSE)
}
\arguments{
  \item{datadir}{Root directory where data is stored.}
  \item{Subset}{Function taking a snapshot as parameter.}
  \item{remove.duplicates}{If TRUE only keep one snapshot per date.}
  \item{flv}{Flavor to select.}
}

\value{
  \code{SnapshotIndex} builds an index of CRAN snapshots from CSV
  converted checking results. Subset is a function used to select a
  subset of each snapshot to return.

  \code{CRANCheckHistory} returns the history of CRAN check results for
  a single flavor.

  \code{flv} returns the history of available flavors.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{check}
\keyword{status}
\keyword{R CMD check}
