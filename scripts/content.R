source("scripts/main.R")

options(expressions = 100000)

library(cloneR)
library(extractoR.content)

rdata <- LoadRData("/data/cran/rds")
packages <- rdata$packages[c("package", "version")]

datadir <- "/data/cran"
pkg.dir <- file.path(datadir, "packages")
func.dir <- file.path(datadir, "functions")
log.dir <- file.path(datadir, "log/functions")

system.time(res <- BrowseFunctions(packages, pkg.dir, func.dir, log.dir))
print(table(sapply(res, function(x) x$res)))
