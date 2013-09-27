source("scripts/main.R")
source("scripts/sql.R")

ReadAndInsertCheckings(con, "data/checks")
