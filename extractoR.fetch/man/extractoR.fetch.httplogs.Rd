\name{HttpLogs}
\alias{HttpLogs}
\alias{FetchLogsList}
\alias{DownloadMissingLogs}
\encoding{UTF-8}
\title{HttpLogs}
\description{
  Fetches logs of CRAN http mirror servers.
}

\usage{
FetchLogsList(url)
DownloadMissingLogs(logs, datadir)
}
\arguments{
  \item{url}{URL of the http mirror server to fetch log from.}
  \item{logs}{Logs vector like the one returned by
    \code{FetchLogsList}.}
  \item{datadir}{Directory where to store downloaded logs.}
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\examples{
\dontrun{
logs <- FetchLogsList("http://cran-logs.rstudio.com")
DownloadMissingLogs(logs, "data")
}
}

\keyword{logs}
\keyword{mirror}
\keyword{cran}
\keyword{fetch}
\keyword{download}