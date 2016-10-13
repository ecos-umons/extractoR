library(extractoR)
library(logging)

basicConfig()

datadir <- "/data/rdata"
mirror <- getCRANmirrors()$URL[grepl("0-Cloud", getCRANmirrors()$Name,
                                     ignore.case=FALSE)][1]

system.time({
  res <- UpdateIndex(datadir,
                     cran.params=list(cran.mirror=mirror),
                     github.params=list(fetch=TRUE, update=TRUE, cluster.size=4))
})
