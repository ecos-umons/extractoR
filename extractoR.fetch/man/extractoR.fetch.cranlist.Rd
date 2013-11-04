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
  \item{current}{All non-archived packages in a dataframe containing the
    size, mtime and filename.}
  \item{rversions}{A list where each element is a vector containing all
    recommended archives for that R version.}
  \item{archived}{All archived packages in a dataframe containing the
    size, mtime and filename.}
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