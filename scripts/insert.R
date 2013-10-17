source("scripts/main.R")
source("scripts/sql.R")

rdata <- LoadRData("data/rds")
InsertAll(con, rdata)
