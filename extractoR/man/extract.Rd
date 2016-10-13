\name{Extract}
\alias{Extract}
\alias{ExtractDescriptionFiles}
\alias{ExtractDependencies}
\alias{ExtractRoles}
\alias{ExtractNamespaceFiles}
\alias{ExtractPackages}
\encoding{UTF-8}
\title{Extract}
\description{
  Extract R meta-data
}

\usage{
ExtractDescriptionFiles(datadir, db="rdata", host="mongodb://localhost")
ExtractDependencies(datadir, db="rdata", host="mongodb://localhost")
ExtractRoles(datadir, db="rdata", host="mongodb://localhost")
ExtractNamespaceFiles(datadir, db="rdata", host="mongodb://localhost")
ExtractPackages(datadir, db="rdata", host="mongodb://localhost")
}
\arguments{
  \item{datadir}{Directory where to store data}
  \item{db}{MongoDB database.}
  \item{host}{MongoDB host.}
}
\details{
  Parses DESCRIPTION file content, dependencies, package maintainers,
  NAMESPACE file content, and package list.
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
\keyword{extract}
\keyword{broken}
\keyword{package}