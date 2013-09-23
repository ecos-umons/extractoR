\name{RData}
\alias{RData}
\alias{SaveRData}
\alias{LoadRData}
\encoding{UTF-8}
\title{RData}
\description{
  Saves and loads object containing informations extracted by extractoR.
}

\usage{
SaveRData(object, datadir)
LoadRData(object, datadir)
}
\arguments{
  \item{object}{A character string with the name of the variable of the
    object to save}
  \item{datadir}{Directory where to save/load objects}
}
\value{
  \code{SaveRData} saves a single object in a RDS file in datadir.

  \code{LoadRData} reads all RDS files and returns a list where all
  elements are the objects contained into the RDS files.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{data}
\keyword{save}
\keyword{load}
\keyword{rds}
