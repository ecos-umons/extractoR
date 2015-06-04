\name{FetchCRANList}
\alias{FetchCRANList}
\encoding{UTF-8}
\title{FetchCRANList}
\description{
  Fetches the list of all package archives (archived, non-archived) of CRAN.
}

\usage{
FetchCRANList(cran.mirror="http://cran.r-project.org")
}
\arguments{
  \item{cran.mirror}{Root URL of the CRAN mirror to use.}
}
\value{
  A \code{data.table} containing the list of packages
  A list containing a dataframe with packages and a character vector
  with R versions. The dataframe contains the columns:
  \item{package}{The package name.}
  \item{version}{The version of the package.}
  \item{archived}{\code{TRUE} if the package is archived.}
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