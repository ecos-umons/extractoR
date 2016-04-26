library(extractoR.github)
library(logging)

basicConfig()

datadir <- "/data/rdata/github"
index <- readRDS("/data/rdata/github/rds/index.rds")

travis <- MakeTravisIndex(index, file.path(datadir, "repos"))
write.csv(travis, file="r-travis.csv", row.names=FALSE)
