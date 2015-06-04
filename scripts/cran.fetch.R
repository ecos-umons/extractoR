source("scripts/main.R")

system.time(res <- extractoR::Fetch(datadir, cran.mirror=mirror))
