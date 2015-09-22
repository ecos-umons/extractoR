\name{Checks}
\alias{Checks}
\alias{ListCheckings}
\alias{ReadChecking}
\alias{ConvertCSV}
\encoding{UTF-8}
\title{Checks}
\description{
  Functions used to read R CMD check informations.
}

\usage{
ListCheckings(checkdir)
ReadChecking(date, dir, filename, checkdir, extract.maintainer=FALSE)
ConvertCSV(checks, datadir)
}
\arguments{
  \item{checkdir}{Root dir where all check files are stored.}
  \item{date}{The date of the checking to extract.}
  \item{dir}{The directory where the RDS file is stored formatted using
    the format "\%y-\%m-\%d-\%H-\%M".}
  \item{filename}{Name of the RDS file to read.}
  \item{extract.maintainer}{Boolean flag for extracting information
    about maintainers}
  \item{checks}{\code{data.table} like the one returned by
    \code{ListChecking}.}
  \item{datadir}{Root directory where data is stored.}
}

\value{
  \code{ListCheckings} lists available checking RDS file and returns a
  vector containing the directories name where the different checking
  RDS files are stored for each extraction. Those directories should be
  named using the date format "\%y-\%m-\%d-\%H-\%M".

  \code{ReadChecking} reads checking RDS files and returns a
  \code{data.table} containing the rows of file plus a
  column with the date of the check.

  \code{ConvertCSV} converts to CSV checking results.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{check}
\keyword{status}
\keyword{R CMD check}
