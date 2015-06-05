\name{Fetch}
\alias{Fetch}
\alias{CRANFetch}
\alias{GithubFetch}
\encoding{UTF-8}
\title{Fetch}
\description{
  Fetch R package data
}

\usage{
CRANFetch(datadir, cran.mirror="http://cran.r-project.org")
GithubFetch(datadir, fetch=TRUE, update=TRUE, cluster.size=4,
            ignore=c("cran", "rpkg", "Bioconductor-mirror"))
}
\arguments{
  \item{datadir}{Directory where to store data}
  \item{cran.mirror}{Root URL of the CRAN mirror to use.}
  \item{fetch}{If FALSE will not clone or update any git repository and
    will just build the package index.}
  \item{update}{If TRUE will make a git pull inside each already
    existing git repository. If not will only clone those that are not
    present.}
  \item{cluster.size}{Number of cluster nodes to use for the git
    repository clone/pull.}
  \item{ignore}{Repository owners to ignore.}
}
\details{
  \code{CRANFetch} fetches last package list from CRAN and downloads
  missing package on disk.

  \code{GithubFetch} clones or updates R package Github repositories.

  These two functions will also build the index required by
  \code{extractoR.extract::MakeGeneralIndex}.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{fetch}
\keyword{cran}
\keyword{github}
\keyword{repository}
\keyword{package}