library(extractoR)
library(logging)

datadir <- "/data/rdata"

basicConfig()

GithubFetch(datadir, fetch=FALSE, update=FALSE, cluster=4)
