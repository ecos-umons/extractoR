\name{ExtractHttpLog}
\alias{ExtractHttpLog}
\encoding{UTF-8}
\title{ExtractHttpLog}
\description{
  Extracts CRAN HTTP mirror server logs.
}

\usage{
ExtractHttpLog(logfile)
}
\arguments{
  \item{logfile}{The path to the log file from where to extract log
    informations.}
}
\value{
  Returns a dataframe where each row is a download and columns are:
  \item{date}{The date and time of download.}
  \item{size}{Size of the downloaded package.}
  \item{r_version}{Version of R.}
  \item{r_arch}{Architecture of the system.}
  \item{r_os}{Operating system.}
  \item{package}{Name of the downloaded package.}
  \item{version}{Version of the downloaded package.}
  \item{country}{Two letter ISO country code.}
  \item{ip_id}{Unique IP identifier of the downloader.}
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{log}
\keyword{extract}
