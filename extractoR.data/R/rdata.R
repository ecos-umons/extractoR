SaveRData <- function(rdata, datadir, subdir=".", format="rds",
                      FUNC=saveRDS, ...) {
  datadir <- file.path(datadir, format, subdir)
  dir.create(datadir, recursive=TRUE, showWarnings=FALSE)
  for (name in names(rdata)) {
    filename <- file.path(datadir, sprintf("%s.%s", name, format))
    loginfo("Saving %s", filename, logger="extractoR.data")
    FUNC(rdata[[name]], file=filename, ...)
  }
}

LoadRData <- function(datadir, subdir=".", format="rds", FUNC=readRDS, ...) {
  datadir <- file.path(datadir, format, subdir)
  extension <- sprintf("\\.%s$", format)
  files <- grep(extension, dir(datadir), value=TRUE)
  rdata <- lapply(files, function(f) {
    loginfo("Loading %s", f, logger="extractoR.data")
    FUNC(file=file.path(datadir, f), ...)
  })
  names(rdata) <- sub(extension, "", files)
  rdata
}

SaveCSV <- function(rdata, datadir, subdir=".") {
  rdata <- rdata[sapply(rdata, inherits, "data.table")]
  SaveRData(rdata, datadir, subdir, format="csv", FUNC=write.csv,
            row.names=FALSE)
}

LoadCSV <- function(datadir, subdir=".") {
  cran <- LoadRData(datadir, subdir, format="csv", FUNC=read.csv,
                    stringsAsFactor=FALSE)
  lapply(cran, as.data.table)
}

SaveJSON <- function(rdata, datadir, subdir=".") {
  rdata <- rdata[sapply(rdata, inherits, "list")]
  SaveRData(rdata, datadir, subdir, format="json",
            FUNC=function(x, file) cat(toJSON(x), file=file))
}

LoadJSON <- function(datadir, subdir=".") {
  LoadRData(datadir, subdir, format="json", FUNC=fromJSON)
}

SaveYAML <- function(rdata, datadir, subdir=".") {
  rdata <- rdata[sapply(rdata, inherits, "list")]
  SaveRData(rdata, datadir, subdir, format="yml",
            FUNC=function(x, file) cat(as.yaml(x), file=file))
}

LoadYAML <- function(datadir, subdir=".") {
  LoadRData(datadir, subdir, format="yml", FUNC=yaml.load_file)
}
