\name{RepositoryTags}
\alias{RepositoryTags}
\encoding{UTF-8}
\title{RepositoryTags}
\description{
  List tags contained in Github git repositories.
}

\usage{
RepositoryTags(github, datadir)
}
\arguments{
  \item{github}{Github snapshot table.}
  \item{datadir}{Root directory where data is stored.}
}
\value{
  Returns a \code{data.table} with the tags and associated commit for
  eeach repository.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{github}
\keyword{package}
\keyword{repository}
\keyword{tag}