\name{TestGithubRepository}
\alias{TestGithubRepository}
\encoding{UTF-8}
\title{TestGithubRepository}
\description{
  Test whether a repository contains a R package.
}

\usage{
TestGithubRepository(owner, name, subdir=".")
}
\arguments{
  \item{owner}{The name of the owner of the repository.}
  \item{name}{The name of the repository.}
  \item{subdir}{The subdirectory of the repository.}
}
\value{
  \code{TRUE} if the github repository contains a R package.
}
\details{
  The function tests whether the subdirectory of the repository contains
  a DESCRIPTION file using HTTP requests. It follows HTTP redirections
  and returns \code{FALSE} when the HTTP request gives a respond code
  different than 200 or 301.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{test}
\keyword{github}
\keyword{package}
\keyword{repository}