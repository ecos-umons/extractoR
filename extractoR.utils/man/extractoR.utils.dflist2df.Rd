\name{dflist2df}
\alias{dflist2df}
\encoding{UTF-8}
\title{dflist2df}
\description{
  Converts a list of dataframes having the same columns to a single
  dataframe.
}

\usage{
dflist2df(l)
}
\arguments{
  \item{l}{A list where all elements are dataframes with the same
    columns.}
  \item{keep.rownames}{Keep rownames if TRUE.}
}
\value{
  The dataframe which is the concatenation of all rows of all dataframes
  of the list.
}

\author{
  Maëlick Claes <himself@maelick.net> & Philippe Grosjean
  <Philippe.Grosjean@umons.ac.be>
}

\examples{
l <- sapply(1:3, function(n) data.frame(x=n, y=n:(n*n)))
dflist2df(l)
}

\keyword{parse}
\keyword{archive}
\keyword{name}
\keyword{package}
