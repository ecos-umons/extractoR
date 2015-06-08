\name{BrokenPackages}
\alias{BrokenPackages}
\encoding{UTF-8}
\title{Descfiles}
\description{
  Identification of broken packages
}

\usage{
BrokenPackages(descfiles, index)
}
\arguments{
  \item{descfiles}{DESCRIPTION files}
  \item{index}{Repository index}
}
\value{
  Tells which packages are broken, i.e. don't have a single valid
  Package and Version entry in the DESCRIPTION file and well formatted
  dependencies.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{broken}
\keyword{packages}
