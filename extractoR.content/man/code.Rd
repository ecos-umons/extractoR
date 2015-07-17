\name{Code}
\alias{Code}
\alias{FunctionDefinitions}
\alias{FunctionCalls}
\alias{CodingStyle}
\encoding{UTF-8}
\title{Code}
\description{
  Extract informations from parsed packages functions with sourceR.
}

\usage{
FunctionDefinitions(package)
FunctionCalls(package)
CodingStyle(package)
}
\arguments{
  \item{package}{\code{package.code} object containing parsed R code of
    a package.}
}
\value{
  \code{FunctionDefinitions} stores result of
  \code{sourceR::FunctionDefinitions} into
  \code{datadir}/functions/\code{source}/\code{repository}/\code{ref}.rds.

  \code{FunctionCalls} stores result of \code{sourceR::FunctioNCalls}
  into
  \code{datadir}/calls/\code{source}/\code{repository}/\code{ref}.rds.

  \code{CodingStyle} stores result of \code{sourceR::CodingStyle} into
  \code{datadir}/codingstyle/\code{source}/\code{repository}/\code{ref}.rds.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{code}
\keyword{package}
\keyword{functions}
\keyword{calls}
\keyword{style}
