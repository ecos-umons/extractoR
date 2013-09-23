\name{extractoR.sql-package}
\alias{extractoR.sql-package}
\alias{extractoR.sql}
\docType{package}
\encoding{UTF-8}
\title{CRAN packages metadata extractor (query)}
\description{
  extractoR.query is part of extractoR which is a set of R packages
  that can be used to fetch, extract and query CRAN packages
  metadata. extractoR.sql exports data to SQL databases.
}

\author{
Maëlick Claes <himself@maelick.net> & Prateek Rastogi <p.rastogi@outlook.com>

Maintainer: Maëlick Claes <himself@maelick.net>
}

\examples{
\dontrun{
library(RMySQL)
library(extractoR.utils)
library(extractoR.sql)

dbuser <- "user"
dbpass <- "password"
dbname <- "rdata"

con <- dbConnect(MySQL(), user=dbuser, password=dbpass, dbname=dbname)
dbClearResult(dbSendQuery(con, "SET NAMES utf8"))
dbClearResult(dbSendQuery(con, "SET collation_connection=utf8_bin"))
dbClearResult(dbSendQuery(con, "SET collation_server=utf8_bin"))

rdata <- LoadRData("data/rds")

InsertRVersions(con, rdata$rversions)
InsertPackages(con, rdata$packages$package)
InsertVersions(con, rdata$packages)
InsertDescfiles(con, rdata$descfiles)
InsertDates(con, rdata$dates)
InsertDependencies(con, rdata$dependencies)
InsertDependencyConstraints(con, rdata$dependencies)
InsertPeople(con, rdata$people)
InsertRoles(con, rdata$roles)
}
}