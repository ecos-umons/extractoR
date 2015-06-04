\name{MakeCRANIndex}
\alias{MakeCRANIndex}
\encoding{UTF-8}
\title{MakeCRANIndex}
\description{
  Downloads and extracts a list packages in datadir.
}

\usage{
MakeCRANIndex(packages)
}
\arguments{
  \item{packages}{CRAN package list like the one returned by
    \code{FetchCRANList}.}
}
\value{
  Returns an index of CRAN packages.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{package}
\keyword{index}
