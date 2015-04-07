\name{Extract}
\alias{Extract}
\encoding{UTF-8}
\title{Extract}
\description{
  Extract CRAN data
}

\usage{
Extract(datadir)
}
\arguments{
  \item{datadir}{Directory where to store data}
}
\details{
  Extracts all informations from package list in
  <datadir>/packages.yml and save them in RDS files in <datadir>/rds.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{fetch}
\keyword{cran}
\keyword{package}