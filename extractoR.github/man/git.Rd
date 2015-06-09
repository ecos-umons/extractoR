\name{Git}
\alias{Git}
\alias{RunGit}
\alias{ParseDate}
\encoding{UTF-8}
\title{Git}
\description{
  Git helpers
}

\usage{
RunGit(FUNC, directory)
ParseDate(date)
}
\arguments{
  \item{FUNC}{Function to run.}
  \item{directory}{Directory where is stored the git repository.}
  \item{date}{Character string containing the date.}
}
\value{
  \code{RunGit} change working directory to a git repository and runs
  \code{FUNC} before restoring previous working directory. Its helpful
  to make calls to git commands inside \code{FUNC}

  \code{ParseDate} converts a git time string in ISO format to a R
  character string without time zone modifier
  (\code{format="\%Y-\%m-\%d \%H:\%M:\%S"}).
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{fetch}
\keyword{github}
\keyword{package}
\keyword{repository}