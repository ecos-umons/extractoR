\name{Checks}
\alias{Checks}
\alias{ListCheckings}
\alias{ReadCheckings}
\alias{ReadAndInsertCheckings}
\encoding{UTF-8}
\title{Checks}
\description{
  Functions used to read checking informations.
}

\usage{
ListCheckings(checkdir, from.date="1970-01-01", to.date=NA)
ReadCheckings(date, filename, checkdir)
ReadAndInsertCheckings(con, checkdir, from.date="1970-01-01", to.date=NA)
}
\arguments{
  \item{checkdir}{Root dir where all checking files are stored.}
  \item{from.date}{Oldest checking to read.}
  \item{to.date}{Newest checking to read.}
  \item{date}{The date of the checking to extract. It must be formatted
    using the format "%y-%m-%d-%H-%M". It is the directory where the RDS
    file is stored.}
  \item{filename}{Name of the RDS file to read.}
  \item{con}{Connection object to the database.}
}
\details{
  \code{ReadAndInsert} reads CRAN status and checkings and inserts them
  into a database.
}

\value{
  \code{ReadCheckings} reads checking RDS files and returns adataframe
  containing the row of the read rds file plus a column with the date of
  the check.

  \code{} lists available checking RDS file and returns a vector
  containing the directories name where the different checking RDS files
  are stored for each extraction. Those directories shoudl be named
  using the date format "%y-%m-%d-%H-%M".
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{cran}
\keyword{check}
\keyword{R CMD check}
