\name{FetchPackages}
\alias{FetchPackages}
\encoding{UTF-8}
\title{FetchPackages}
\description{
  Downloads and extracts a list packages in datadir.
}

\usage{
FetchPackages(packages, datadir,
cran.mirror="http://cran.r-project.org")
}
\arguments{
  \item{packages}{A list of packages like the one returned by
    \code{FetchCRANList}}
  \item{datadir}{Directory where to store and extract the packages.}
  \item{cran.mirror}{Root URL of the CRAN mirror to use.}
}
\value{
  A logical vector telling where a value is TRUE iff the package
  has been donwloaded.
}
\details{
  Packages are extracted to <datadir>/<package>/<versions> and they are
  downloaded iff this directory doesn't exist.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\examples{
\dontrun{
FetchPackages(LoadPackagesList("packages.yml"), "./packages/")
}
}

\keyword{parse}
\keyword{archive}
\keyword{name}
\keyword{package}