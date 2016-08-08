SaveRData <- function(rdata, datadir, subdir=".", format="rds",
                      FUNC=saveRDS, FILTER=base::identity, ...) {
  datadir <- file.path(datadir, format, subdir)
  dir.create(datadir, recursive=TRUE, showWarnings=FALSE)
  for (name in FILTER(names(rdata))) {
    filename <- file.path(datadir, sprintf("%s.%s", name, format))
    loginfo("Saving %s", filename, logger="extractoR.data")
    FUNC(rdata[[name]], file=filename, ...)
  }
}

LoadRData <- function(datadir, subdir=".", format="rds",
                      FUNC=readRDS, FILTER=base::identity, ...) {
  datadir <- file.path(datadir, format, subdir)
  extension <- sprintf("\\.%s$", format)
  files <- grep(extension, dir(datadir), value=TRUE)
  files <- sprintf("%s.%s", FILTER(sub(extension, "", files)), format)
  rdata <- lapply(files, function(f) {
    loginfo("Loading %s", f, logger="extractoR.data")
    FUNC(file=file.path(datadir, f), ...)
  })
  names(rdata) <- sub(extension, "", files)
  rdata
}

SaveCSV <- function(rdata, datadir, subdir=".", FILTER=base::identity) {
  rdata <- rdata[sapply(rdata, inherits, "data.table")]
  SaveRData(rdata, datadir, subdir, format="csv", FUNC=write.csv, FILTER,
            row.names=FALSE)
}

LoadFastCSV <- function(datadir, subdir=".", FILTER=base::identity) {
  LoadRData(datadir, subdir, format="csv", FUNC=function(file) {
    fread(file)
  }, FILTER)
}

LoadCSV <- function(datadir, subdir=".", FILTER=base::identity) {
  res <- LoadRData(datadir, subdir, format="csv", FUNC=read.csv, FILTER,
                    stringsAsFactor=FALSE)
  lapply(res, as.data.table)
}

SaveJSON <- function(rdata, datadir, subdir=".", FILTER=base::identity) {
  rdata <- rdata[sapply(rdata, inherits, "list")]
  SaveRData(rdata, datadir, subdir, format="json",
            FUNC=function(x, file) cat(toJSON(x), file=file), FILTER)
}

LoadJSON <- function(datadir, subdir=".", FILTER=base::identity) {
  LoadRData(datadir, subdir, format="json", FUNC=fromJSON, FILTER)
}

SaveYAML <- function(rdata, datadir, subdir=".", FILTER=base::identity) {
  rdata <- rdata[sapply(rdata, inherits, "list")]
  SaveRData(rdata, datadir, subdir, format="yml",
            FUNC=function(x, file) cat(as.yaml(x), file=file), FILTER)
}

LoadYAML <- function(datadir, subdir=".", FILTER=base::identity) {
  LoadRData(datadir, subdir, format="yml", FUNC=yaml.load_file, FILTER)
}

SaveFeather <- function(rdata, datadir, subdir=".", FILTER=base::identity) {
  rdata <- rdata[sapply(rdata, inherits, "data.table")]
  SaveRData(rdata, datadir, subdir, format="feather.gz", FUNC=function(data, file) {
    ## write_feather(data, gzfile(file))
    write_feather(data, file)
  }, FILTER)
}

LoadFeather <- function(datadir, subdir=".", FILTER=base::identity) {
  res <- LoadRData(datadir, subdir, format="feather.gz", FUNC=function(file) {
    ## read_feather(gzfile(file))
    read_feather(file)
  }, FILTER)
  lapply(res, as.data.table)
}
