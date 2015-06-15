Extract <- function(datadir) {
  rdata <- list()
  index <- readRDS(file.path(datadir, "rds", "index.rds"))
  descfiles <- readRDS(file.path(datadir, "rds", "descfiles.rds"))
  namespaces <- readRDS(file.path(datadir, "rds", "namespaces.rds"))

  message("Extracting broken packages")
  t <- system.time({
    rdata$broken <- BrokenPackages(descfiles, namespaces, index)
  })
  message(sprintf("Broken packages extracted in %.3fs", t[3]))

  message("Extracting packages")
  t <- system.time({
    rdata$packages <- Packages(descfiles, rdata$broken)
  })
  message(sprintf("Packages extracted in %.3fs", t[3]))

  message("Saving objects in data/rds")
  t <- system.time({
    SaveRData(rdata, datadir)
    SaveCSV(rdata, datadir)
  })
  message(sprintf("Objects saved in %.3fs", t[3]))
}
