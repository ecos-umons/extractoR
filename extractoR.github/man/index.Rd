\name{GithubIndex}
\alias{GithubIndex}
\alias{MakeGithubIndex}
\alias{MakeRepositoryId}
\encoding{UTF-8}
\title{GithubIndex}
\description{
  Makes an index of DESCRIPTION files versions in Github repositories.
}

\usage{
MakeGithubIndex(github, datadir,
                ignore=c("cran", "rpkg", "Bioconductor-mirror"))
MakeRepositoryId(owner, repo, subdir)
}
\arguments{
  \item{github}{Github snapshot table.}
  \item{datadir}{Root directory where data is stored.}
  \item{owner}{The name of the owner of the repository.}
  \item{repo}{The name of the repository.}
  \item{subdir}{Subdirectory in the repository where the package is located.}
  \item{ignore}{Repository owners to ignore.}
}
\value{
  \code{MakeGithubIndex} returns an index of package versions from the
  repositories passed as parameters.

  \code{MakeRepositoryId} returns a character string id correspond to
  the repositories passed as parameters.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{fetch}
\keyword{github}
\keyword{package}
\keyword{repository}