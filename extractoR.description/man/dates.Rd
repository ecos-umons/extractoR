\name{ExtractDates}
\alias{ExtractDates}
\alias{ExtractTimeline}
\encoding{UTF-8}
\title{ExtractDates}
\description{
  Extracts dates information from DESCRIPTION files.
}

\usage{
ExtractDates(descfiles, type)
}
\arguments{
  \item{descfiles}{A \code{data.table} containing DESCRIPTION files (like the
    one returned by \code{ReadDescFiles}).}
  \item{type}{A type of date (either "Date/Publication", "Packaged" or
    "Date")}
}
\value{
  \code{ExtractDates} returns a four column dataframe with package name,
  version, date type and the date.

  % \code{ExtractTimeline} returns a three column dataframe with package
  % name, version and a date. This functions takes dates extracted by
  % ExtractDates and select for each package and version a unique date
  % which is the "Date/Publication" if it exists for the package version,
  % "Packaged" if it doesn't exist and "Date" if both don't exist.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{dates}
\keyword{extract}
