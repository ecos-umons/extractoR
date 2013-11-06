\name{FetchCRANList}
\alias{FetchCRANList}
\encoding{UTF-8}
\title{FetchCRANList}
\description{
  Fetches the list of all package archives (archived, non-archived and
  recommded in all R's versions) of CRAN.
}

\usage{
FetchCRANList(cran.mirror="http://cran.r-project.org")
}
\arguments{
  \item{cran.mirror}{Root URL of the CRAN mirror to use.}
}
\value{
  A list containing a dataframe with packages and a character vector
  with R versions. The dataframe contains the columns:
  \item{package}{The package name.}
  \item{version}{The version of the package.}
  \item{filename}{The filename of the archive.}
  \item{type}{The type of the package: "current" if the package is not
    archived, "archived" if it is or the R version for which this
    package is a recommended package.}
  \item{size}{The size of the package archive}
  \item{mtime}{The modification time of the package archive which should
    normally be the time when it was released on CRAN.}
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\examples{
\dontrun{
FetchCRANList()
}
}

\keyword{parse}
\keyword{archive}
\keyword{name}
\keyword{package}