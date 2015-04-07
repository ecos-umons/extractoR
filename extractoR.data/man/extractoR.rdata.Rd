\name{RData}
\alias{RData}
\alias{SaveCSV}
\alias{LoadCSV}
\alias{SaveRData}
\alias{LoadRData}
\encoding{UTF-8}
\title{RData}
\description{
  Saves and loads object containing informations extracted by extractoR.
}

\usage{
SaveRData(rdata, datadir, format="rds", FUNC=saveRDS, ...)
LoadRData(datadir, format="rds", FUNC=readRDS, ...)
}
\arguments{
  \item{rdata}{A list containing objects to be saved}
  \item{datadir}{Directory where to save/load objects}
  \item{format}{Format used to save/load \code{data.table} objects}
  \item{FUNC}{Function used to read/write from file}
  \item{...}{Additional arguments to pass to \code{FUNC}}
}
\value{
  \code{SaveRData} saves elements each element of a list. By default
  saves to RDS file.

  \code{LoadRData} reads all files and returns a list where all
  elements are the objects contained into the data files. By default
  loads RDS files.

  \code{SaveCSV} and \code{LoadCSV} calls \code{SaveRData} and
  \code{LoadRData} but saves to csv rather than rds.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{data}
\keyword{save}
\keyword{load}
\keyword{rds}
\keyword{csv}