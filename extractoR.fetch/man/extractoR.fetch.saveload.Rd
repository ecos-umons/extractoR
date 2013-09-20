\name{SaveLoadPackagesList}
\alias{SaveLoadPackagesList}
\alias{SavePackagesList}
\alias{LoadPackagesList}
\encoding{UTF-8}
\title{Save & Load PackagesList}
\description{
  Those functions are used to save/load a list of packages to/from a
  YAML file.
}

\usage{
SavePackagesList(packages, filename)
LoadPackagesList(filename)
}
\arguments{
  \item{packages}{A list of packages like the one returned by
    \code{FetchCRANList}}
  \item{filename}{The name of the YAML file.}
}
\value{
  \item{package}{The name of the package.}
  \item{version}{The version of the package.}
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\examples{
\dontrun{
SavePackagesList(FetchCRANList(), "packages.yml")
LoadPackagesList("packages.yml")
}
}

\keyword{parse}
\keyword{archive}
\keyword{name}
\keyword{package}