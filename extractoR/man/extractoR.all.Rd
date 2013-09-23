\name{Insert}
\alias{All}
\alias{FetchAll}
\alias{ExtractAll}
\alias{InsertAll}
\alias{UpdateTaskViews}
\encoding{UTF-8}
\title{Insert}
\description{
  Main extractoR functions.
}

\usage{
FetchAll(datadir, cran.mirror="http://cran.r-project.org")
ExtractAll(datadir)
InsertAll(con, rdata)
UpdateTaskViews(con, cran.mirror)
}
\arguments{
  \item{datadir}{Directory where to store data}
  \item{cran.mirror}{Root URL of the CRAN mirror to use.}
  \item{con}{Connection object to the database.}
  \item{rdata}{Rdata.}
}
\details{
  \code{FetchAll} fetches last package list from CRAN and downloads
  missing package on disk. Package list is saved to
  <datadir>/packages.yml and unarchived packages to <datadir>/packages.

  \code{ExtractAll} extracts all informations from package list in
  <datadir>/packages.yml and save them in RDS files in <datadir>/rds.

  \code{InsertAll} inserts all data saved into <datadir>/rds in all
  tables (except ones related to taskviews).

  \code{UpdateTaskViews} extracts last taskviews from CRAN and
  inserts them into SQL tables.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{fetch}
\keyword{cran}
\keyword{extract}
\keyword{insert}
\keyword{sql}
