library(extractoR)

datadir <- "/data/rdata"
mirror <- as.data.table(getCRANmirrors())[City == "0-Cloud", URL]

system.time(res <- CRANFetch(datadir, cran.mirror=mirror))
