library(extractoR)
library(logging)

basicConfig()

datadir <- "/data/rdata"
mirror <- as.data.table(getCRANmirrors())[City == "0-Cloud", URL[1]]

system.time(res <-
  UpdateIndex(datadir,
              cran.params=list(cran.mirror=mirror),
              github.params=list(fetch=TRUE, update=TRUE, cluster=4))
