source("scripts/main.R")
source("scripts/sql.R")

ReadAndInsertStatus(con, "data/checks", from.date="2013-09-10 03:00:00")
