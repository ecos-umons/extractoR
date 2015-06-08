MakeGlobalIndex <- function(datadir, sources=c("cran", "github")) {
  rbindlist(lapply(file.path(datadir, sources, "csv", "index.csv"), fread))
}
