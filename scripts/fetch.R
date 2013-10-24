source("scripts/main.R")

system.time(res <- FetchAll("data", cran.mirror=mirror))
