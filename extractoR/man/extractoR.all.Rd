\name{Insert}
\alias{All}
\alias{InsertAll}
\encoding{UTF-8}
\title{Insert}
\description{
  Main extractoR functions.
}

\usage{
FetchAll(datadir, cran.mirror="http://cran.r-project.org")
ExtractAll(datadir)
InsertAll(con, rdata)
ExtractInsertTaskViews(con)
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

  \code{ExtractInsertTaskView} extracts last taskviews from CRAN and
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

\examples{
library(extractoR)

FetchAll("data")
ExtractAll("data")


dbuser <- "user"
dbpass <- "password"
dbname <- "rdata"

con <- dbConnect(MySQL(), user=dbuser, password=dbpass, dbname=dbname)
dbClearResult(dbSendQuery(con, "SET NAMES utf8"))
dbClearResult(dbSendQuery(con, "SET collation_connection=utf8_bin"))
dbClearResult(dbSendQuery(con, "SET collation_server=utf8_bin"))

rdata <- LoadRData("data/rds")

InsertAll(con)
ExtractInsertTaskViews(con)
}