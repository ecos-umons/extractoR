library(extractoR)

datadir <- "/data/rdata"
mirror <- as.data.table(getCRANmirrors())[City == "0-Cloud", URL[1]]

system.time(res <- CRANFetch(datadir, cran.mirror=mirror))
