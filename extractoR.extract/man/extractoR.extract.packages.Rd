\name{GetPackagesDataframe}
\alias{GetPackagesDataframe}
\alias{GetPackagesDataframe}
\encoding{UTF-8}
\title{GetPackagesDataframe}
\description{
  Converts a list of packages to a dataframe.
}

\usage{
GetPackagesDataframe(packages)
}
\arguments{
  \item{packages}{A list of packages like the one returned by
    \code{FetchCRANList}}
}
\value{
  A two column dataframe with packages name and version.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{packages}
\keyword{extract}
