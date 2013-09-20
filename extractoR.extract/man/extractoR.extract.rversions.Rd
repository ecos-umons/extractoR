\name{ExtractRversions}
\alias{ExtractRversions}
\encoding{UTF-8}
\title{ExtractRversions}
\description{
  Extracts the list of recommended packages for all R versions.
}

\usage{
ExtractRversions(packages)
}
\arguments{
  \item{packages}{A list of packages like the one returned by
    \code{FetchCRANList}}
}
\value{
  A three column dataframe with packages name, version and the
  rversion.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{parse}
\keyword{archive}
\keyword{name}
\keyword{package}