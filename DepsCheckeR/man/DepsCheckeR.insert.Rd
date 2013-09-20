\name{Insert}
\alias{Insert}
\alias{InsertFlavors}
\alias{InsertCRANStatus}
\alias{InsertCRANChecking}
\encoding{UTF-8}
\title{Insert}
\description{
  Functions used to insert extractoR.extract's dataframes into SQL
  tables.
}

\usage{
InsertFlavors(con, flavors)
InsertCRANStatus(con, status)
InsertCRANChecking(con, checking)
}
\arguments{
  \item{con}{Connection object to the database.}
  \item{flavors}{Flavors dataframe.}
  \item{status}{CRAN status dataframe.}
  \item{checking}{CRAN checking dataframe.}
}
\details{
  Inserts into tables flavors, cran_status and cran_checking.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{insert}
\keyword{sql}
