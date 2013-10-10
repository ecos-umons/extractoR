source("scripts/main.R")
source("scripts/sql.R")

ReadAndInsertStatus(con, "data/checks", to.date="2013-09-10 03:00:00")
