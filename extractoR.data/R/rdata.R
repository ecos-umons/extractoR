SaveRData <- function(rdata, datadir, format="rds", FUNC=saveRDS, ...) {
  datadir <- file.path(datadir, format)
  dir.create(datadir, recursive=TRUE, showWarnings=FALSE)
  for (name in names(rdata)) {
    filename <- file.path(datadir, sprintf("%s.%s", name, format))
    FUNC(rdata[[name]], file=filename, ...)
  }
}

LoadRData <- function(datadir, format="rds", FUNC=readRDS, ...) {
  datadir <- file.path(datadir, format)
  extension <- sprintf("\\.%s$", format)
  files <- grep(extension, dir(datadir), value=TRUE)
  rdata <- lapply(files, function(f) FUNC(file=file.path(datadir, f), ...))
  names(rdata) <- sub(extension, "", files)
  rdata
}

SaveCSV <- function(rdata, datadir) {
  rdata <- rdata[sapply(rdata, inherits, "data.table")]
  SaveRData(rdata, datadir, format="csv", FUNC=write.csv, row.names=FALSE)
}

LoadCSV <- function(datadir) {
  cran <- LoadRData(datadir, format="csv", FUNC=read.csv, stringsAsFactor=FALSE)
  lapply(cran, as.data.table)
}

SaveJSON <- function(rdata, datadir) {
  rdata <- rdata[sapply(rdata, inherits, "list")]
  SaveRData(rdata, datadir, format="json",
            FUNC=function(x, file) cat(toJSON(x), file=file))
}

LoadJSON <- function(datadir) {
  LoadRData(datadir, format="json", FUNC=fromJSON)
}

SaveYAML <- function(rdata, datadir) {
  rdata <- rdata[sapply(rdata, inherits, "list")]
  SaveRData(rdata, datadir, format="yml",
            FUNC=function(x, file) cat(as.yaml(x), file=file))
}

LoadYAML <- function(datadir) {
  LoadRData(datadir, format="yml", FUNC=function(file) yaml.load_file(file))
}
