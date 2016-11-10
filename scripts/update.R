library(extractoR)
library(logging)

basicConfig()

datadir <- "/data/rdata"
mirror <- getCRANmirrors()$URL[grepl("0-Cloud", getCRANmirrors()$Name,
                                     ignore.case=FALSE)][1]

cran.params <- list(cran.mirror=mirror)
github.params <- list(filter=TRUE, fetch=TRUE, update=TRUE, cluster.size=4)

system.time(UpdateIndex(datadir, "rdata", "mongodb://localhost",
                        cran.params, github.params))
