\name{RepositoryId}
\alias{RepositoryId}
\alias{ParseGithubRepositoryName}
\alias{ParseRepositoryId}
\encoding{UTF-8}
\title{RData}
\description{
  Parses repository id character strings.
}

\usage{
ParseGithubRepositoryName(str)
ParseRepositoryId(str)
}
\arguments{
  \item{str}{Character string to parse.}
}
\value{
  \code{ParseGithubRepositoryName} parses a github repository name of
  the form \code{owner/repository[/subdir]}.

  \code{ParseRepositoryId} parses a repository id of the form
  \code{source:repository[:version]}.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{repository}
\keyword{id}
\keyword{parse}
\keyword{name}
\keyword{github}
