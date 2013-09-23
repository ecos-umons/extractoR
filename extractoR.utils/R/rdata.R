SaveRData <- function(object, datadir) {
  dir.create("data/rds", recursive=TRUE, showWarnings=FALSE)
  filename <- file.path("data/rds", sprintf("%s.rds", object))
  saveRDS(get(object), file=filename)
}

LoadRData <- function(datadir) {
  files <- grep("\\.rds$", dir(datadir), value=TRUE)
  rdata <- lapply(files, function(f) readRDS(file.path(datadir, f)))
  names(rdata) <- sub("\\.rds$", "", files)
  rdata
}
