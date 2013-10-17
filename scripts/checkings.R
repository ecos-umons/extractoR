source("scripts/main.R")
source("scripts/sql.R")

ExtractAndInsertStatus(con, "data/checks",
                       from.date="2013-10-14 03:00:00")
