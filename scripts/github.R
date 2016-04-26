library(extractoR)
library(logging)

datadir <- "/data/rdata"

basicConfig()

GithubFetch(datadir, fetch=TRUE, update=TRUE, cluster=4)
