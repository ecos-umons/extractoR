\name{ExtractDescriptionFiles}
\alias{ExtractDescriptionFiles}
\encoding{UTF-8}
\title{ExtractDescriptionFiles}
\description{
  Parses DESCRIPTION files from R packages.
}

\usage{
ExtractDescriptionFiles(datadir, db="rdata", host="mongodb://localhost")
}
\arguments{
  \item{datadir}{Directory where to store data}
  \item{db}{MongoDB database.}
  \item{host}{MongoDB host.}
}
\details{
  Parses DESCRIPTION file content, dependencies, authors and dates.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{description}
\keyword{dependencies}
\keyword{maintainers}
\keyword{cran}
\keyword{github}
\keyword{package}