\name{ParseArchiveName}
\alias{ParseArchiveName}
\encoding{UTF-8}
\title{ParseArchiveName}
\description{
  Parses the file name of a .tar.gz archive containing a package.
}

\usage{
ParseArchiveName(archive)
}
\arguments{
  \item{archive}{the file name of the archive}
}
\value{
  \item{package}{The name of the package.}
  \item{version}{The version of the package.}
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\examples{
ParseArchiveName("extractoR.extract_1.0.tar.gz")
}

\keyword{parse}
\keyword{archive}
\keyword{name}
\keyword{package}