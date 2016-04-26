\name{Travis}
\alias{Travis}
\alias{MakeTravisIndex}
\encoding{UTF-8}
\title{Travis}
\description{
  Test whether a repository contains a R package.
}

\usage{
MakeTravisIndex(index, datadir)
}
\arguments{
  \item{index}{Repository index.}
  \item{datadir}{Directory where to store and extract the repositories.}
}
\value{
  Returns a list of commits modifying the file ".travis.yml".
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{travis}
\keyword{github}
\keyword{package}
\keyword{repository}