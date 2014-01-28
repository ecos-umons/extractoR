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
SaveRData(rdata, datadir)
LoadRData(datadir)
}
\arguments{
  \item{rdata}{A list containing objects to be saved}
  \item{datadir}{Directory where to save/load objects}
}
\value{
  \code{SaveRData} saves elements each element of a list to a RDS file.

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
