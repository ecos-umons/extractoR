library(RMySQL)

dbuser <- "user"
dbpass <- "password"
dbname <- "database"

con <- dbConnect(MySQL(), user=dbuser, password=dbpass, dbname=dbname)
dbClearResult(dbSendQuery(con, "SET NAMES utf8"))
dbClearResult(dbSendQuery(con, "SET collation_connection=utf8_bin"))
dbClearResult(dbSendQuery(con, "SET collation_server=utf8_bin"))
