\name{Update}
\alias{Update}
\alias{CRANIndex}
\alias{GithubIndex}
\alias{UpdateIndex}
\encoding{UTF-8}
\title{Fetch}
\description{
  Fetch R package data
}

\usage{
CRANIndex(datadir, cran.mirror="http://cran.r-project.org")
GithubIndex(datadir, filter=TRUE, fetch=TRUE, update=TRUE,
            cluster.size=4, ignore=c("cran", "rpkg", "Bioconductor-mirror"))
UpdateIndex(datadir, db="rdata", host="mongodb://localhost",
            cran.params=list(), github.params=list())
}
\arguments{
  \item{cran.mirror}{Root URL of the CRAN mirror to use.}
  \item{filter}{If TRUE will test that GitHub repositories have a
    DESCRIPTION file, if they don't they will be removed from the
    repository list.}
  \item{fetch}{If FALSE will not clone or update any git repository and
    will just build the package index.}
  \item{update}{If TRUE will make a git pull inside each already
    existing git repository. If not will only clone those that are not
    present.}
  \item{cluster.size}{Number of cluster nodes to use for the git
    repository clone/pull.}
  \item{ignore}{Repository owners to ignore.}
  \item{db}{MongoDB database.}
  \item{host}{MongoDB host.}
  \item{datadir}{Directory where to store data}
  \item{cran.params}{Parameter list to pass to \code{CRANIndex}.}
  \item{github.params}{Parameter list to pass to \code{GithubIndex}.}
}
\details{
  \code{CRANIndex} fetches last package list from CRAN and downloads
  missing package on disk.

  \code{GithubIndex} clones or updates R package Github repositories.

  \code{UpdateIndex} runs \code{CRANIndex} and \code{GithubIndex}, and
  updates the repository index on MongoDB.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{fetch}
\keyword{update}
\keyword{cran}
\keyword{github}
\keyword{repository}
\keyword{package}