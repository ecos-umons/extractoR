library(extractoR)

datadir <- "/data/cran"
mirror <- as.data.table(getCRANmirrors())[City == "0-Cloud", URL]

system.time(res <- extractoR::Fetch(datadir, cran.mirror=mirror))
