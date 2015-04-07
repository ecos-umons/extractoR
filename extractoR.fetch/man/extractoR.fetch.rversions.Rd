\name{FetchRVersions}
\alias{FetchRVersions}
\encoding{UTF-8}
\title{FetchRVersions}
\description{
  List all recommended packages included in each R release.
}

\usage{
FetchRVersions(cran.mirror="http://cran.r-project.org")
}
\arguments{
  \item{cran.mirror}{Root URL of the CRAN mirror to use.}
}
\value{
  A \code{data.table} with all recommended packages with their name and
  version, and also their associated R release version number.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\examples{
\dontrun{
FetchRVersions()
}
}

\keyword{parse}
\keyword{archive}
\keyword{name}
\keyword{package}
\keyword{recommended}
\keyword{version}
\keyword{R}