source("scripts/main.R")

mirror <- "http://cran.parentingamerica.com"
system.time(res <- FetchAll("data", cran.mirror=mirror))
