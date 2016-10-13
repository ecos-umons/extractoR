\name{ExtractPackages}
\alias{ExtractPackages}
\encoding{UTF-8}
\title{Extract}
\description{
  Extract R data
}

\usage{
ExtractPackages(datadir, db="rdata", host="mongodb://localhost")
}
\arguments{
  \item{datadir}{Directory where to store data}
  \item{db}{MongoDB database.}
  \item{host}{MongoDB host.}
}
\details{
  Extracts all informations from Github and CRAN packages.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{extract}
\keyword{cran}
\keyword{github}
\keyword{broken}
\keyword{package}