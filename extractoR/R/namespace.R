ParseNamespaceFiles <- function(datadir) {
  index <- MakeGlobalIndex(datadir)

  message("Reading NAMESPACE files")
  t <- system.time({
    namespaces <- Namespaces(index, datadir)
    rdata <- list(namespaces=namespaces)
  })
  message(sprintf("NAMESPACE files read in %.3fs", t[3]))

  message("Saving objects in data/rds")
  t <- system.time({
    SaveRData(rdata, datadir)
    SaveJSON(rdata, datadir)
  })
  message(sprintf("Objects saved in %.3fs", t[3]))
}
