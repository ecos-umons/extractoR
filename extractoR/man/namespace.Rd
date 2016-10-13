\name{ExtractNamespaceFiles}
\alias{ExtractNamespaceFiles}
\encoding{UTF-8}
\title{ExtractNamespaceFiles}
\description{
  Parses NAMESPACE files from R packages.
}

\usage{
ExtractNamespaceFiles(datadir, db="rdata", host="mongodb://localhost")
}
\arguments{
  \item{datadir}{Directory where to store data}
  \item{db}{MongoDB database.}
  \item{host}{MongoDB host.}
}
\details{
  Parses NAMESPACE file content, dependencies, authors and dates.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{namespace}
\keyword{dependencies}
\keyword{import}
\keyword{export}
\keyword{cran}
\keyword{github}
\keyword{package}