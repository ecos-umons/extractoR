\name{Fetch}
\alias{Fetch}
\encoding{UTF-8}
\title{Fetch}
\description{
  Fetch CRAN data
}

\usage{
Fetch(datadir, cran.mirror="http://cran.r-project.org")
}
\arguments{
  \item{datadir}{Directory where to store data}
  \item{cran.mirror}{Root URL of the CRAN mirror to use.}
}
\details{
  Fetches last package list from CRAN and downloads missing package on
  disk. Package list is saved to <datadir>/packages.yml and unarchived
  packages to <datadir>/packages.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{fetch}
\keyword{cran}
\keyword{package}