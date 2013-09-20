\name{Strip}
\alias{Strip}
\alias{LStrip}
\alias{RStrip}
\encoding{UTF-8}
\title{Strip functions}
\description{
  Removes leading and/or trailing blank characters.
}

\usage{
Strip(s)
LStrip(s)
RStrip(s)
}
\arguments{
  \item{s}{the string to removed blank characters}
}
\value{
  \code{LStrip} removes from \code{s} all leading characters,
  \code{RStrip} all trailing characters and \code{Strip} both.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\examples{
Strip(" foo ")
LStrip(" foo ")
RStrip(" foo ")
}

\keyword{space}
\keyword{blank}
\keyword{leading}
\keyword{trailing}
\keyword{strip}
