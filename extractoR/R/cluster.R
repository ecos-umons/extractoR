InitCluster <- function(logger, logfile, n=4) {
  cl <- makeCluster(n, type="PSOCK", outfile="")
  clusterExport(cl, list(logfile="logfile"), envir=environment())
  clusterCall(cl, function() {
    library(logging)
    library(RCurl)

    basicConfig()
    addHandler(writeToFile, logger=logger, file=logfile)
  })
  cl
}
