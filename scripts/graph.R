source("scripts/main.R")
source("scripts/sql.R")

flavor <- "r-release-linux-x86_64"
date <- as.POSIXlt("2013-09-09 15:00:00")
base.packages <- c("R", "base", "compiler", "datasets", "graphics",
                   "grDevices", "grid", "methods", "parallel", "profile",
                   "splines", "stats", "stats4", "tcltk", "tools",
                   "translations", "utils")

cran <- GetCRANState(con, flavor, date)
deps <- GetCRANDeps(con, flavor, date)

checkings <- GetCRANCheckings(con, date)
## checkings <- checkings[checkings$type == "package dependencies", ]

g <- MakeDependencyGraph(cran, deps)
g <- AddPackagesGraphCheckings(g, checkings)

g2 <- MakeMaintainersGraph(cran, deps)
g2 <- AddMaintainersGraphCheckings(g2, checkings)
g2 <- AddMaintainersGraphPackagesCheckings(g2, checkings)
g2 <- AddMaintainersGraphRelativePackagesCheckings(g2, checkings)

write.graph(g, "deps.graphml", "graphml")
write.graph(g2, "deps_people.graphml", "graphml")
