\name{FetchPackage}
\alias{FetchPackage}
\encoding{UTF-8}
\title{FetchPackage}
\description{
  Downloads and extracts a list packages in datadir.
}

\usage{
FetchPackage(package, version, datadir, cran.mirror="http://cran.r-project.org")
}
\arguments{
  \item{package}{The name of the package to fetch.}
  \item{version}{The version of the package to fetch.}
  \item{datadir}{Directory where to store and extract the package.}
  \item{cran.mirror}{Root URL of the CRAN mirror to use.}
}
\value{
  A logical vector telling where a value is TRUE iff the package
  has been donwloaded.
}
\details{
  Packages are extracted to <datadir>/<package>/<version> and they are
  downloaded iff this directory doesn't exist.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\examples{
\dontrun{
FetchPackage("A3", "0.9-1", "data/packages/")
}
}

\keyword{parse}
\keyword{archive}
\keyword{name}
\keyword{package}