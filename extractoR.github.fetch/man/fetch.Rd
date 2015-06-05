\name{FetchGithubRepository}
\alias{FetchGithubRepository}
\encoding{UTF-8}
\title{FetchPackage}
\description{
  Clone or pull github repositories
}

\usage{
FetchGithubRepository(owner, name, datadir, update=TRUE)
}
\arguments{
  \item{owner}{The name of the owner of the repository.}
  \item{name}{The name of the repository.}
  \item{datadir}{Directory where to store and extract the repositories.}
  \item{update}{If TRUE will also update (i.e. pull) existing repositories}
}
\details{
  Repositories cloned/pull in/from the directory
  \code{file.path(datadir, "reos", owner, name)}.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{fetch}
\keyword{github}
\keyword{package}
\keyword{repository}