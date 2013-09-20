\name{ExtractDates}
\alias{ExtractDates}
\encoding{UTF-8}
\title{ExtractDates}
\description{
  Extracts dates information from DESCRIPTION files.
}

\usage{
ExtractDates(descfiles, type)
}
\arguments{
  \item{descfiles}{A dataframe containing DESCRIPTION files (like the
    one returned by ReadDescFiles).}
  \item{type}{A type of date (either "Date/Publication", "Packaged")}
}
\value{
  A four column dataframe with package name, version, date type and the
  date.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{dates}
\keyword{extract}
