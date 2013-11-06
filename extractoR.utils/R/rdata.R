SaveRData <- function(rdata, datadir) {
  dir.create(datadir, recursive=TRUE, showWarnings=FALSE)
  for (name in names(rdata)) {
    filename <- file.path(datadir, sprintf("%s.rds", name))
    saveRDS(rdata[[name]], file=filename)
  }
}

LoadRData <- function(datadir) {
  files <- grep("\\.rds$", dir(datadir), value=TRUE)
  rdata <- lapply(files, function(f) readRDS(file.path(datadir, f)))
  names(rdata) <- sub("\\.rds$", "", files)
  rdata
}
