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

g <- MakeDependencyGraph(con, cran, deps)
g <- AddPackagesGraphCheckings(g, checkings)

g2 <- MakeMaintainersGraph(cran, deps)
g2 <- AddMaintainersGraphCheckings(g2, checkings)
g2 <- AddMaintainersGraphPackagesCheckings(g2, checkings)
g2 <- AddMaintainersGraphRelativePackagesCheckings(g2, checkings)

save(list=c("flavor", "date", "base.packages", "cran", "deps", "checkings", "g", "g2"),
     file="data/graphs/graph.RData")
write.graph(g, "data/graphs/deps.graphml", "graphml")
write.graph(g2, "data/graphs/deps_people.graphml", "graphml")

load("./data/graphs/graph.RData")

write.graph(GetTaskViewPackagesGraph(con, g, date), "data/graphs/tv.graphml", "graphml")
write.graph(GetTaskViewMaintainersGraph(con, g2, date, flavor), "data/graphs/tv_people.graphml", "graphml")

query <- paste("SELECT DISTINCT t.name FROM taskviews t, taskview_versions v",
               "WHERE t.id = v.taskview_id",
               sprintf("AND v.version <= '%s'", date))
taskviews <- dbGetQuery(con, query)$name

for (t in taskviews) {
  write.graph(GetTaskViewPackagesGraph(con, g, date, t),
              file.path("data/graphs", sprintf("%s.graphml", t)), "graphml")
  write.graph(GetTaskViewMaintainersGraph(con, g2, date, flavor, t),
              file.path("data/graphs", sprintf("%s_people.graphml", t)), "graphml")
}
