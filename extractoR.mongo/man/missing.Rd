\name{MissingEntries}
\alias{MissingEntries}
\encoding{UTF-8}
\title{MissingEntries}
\description{
  Missing entries in a collection
}

\usage{
MissingEntries(index, con)
}
\arguments{
  \item{index}{Repository index.}
  \item{con}{\code{mongolite} connection object to collection.}
}
\value{
  A subset of index whose rows are not in MongoDB collection.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{mongo}
\keyword{missing}
