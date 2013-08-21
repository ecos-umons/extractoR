library(RMySQL)

descfile.name <- function(version, package, datadir) {
  paste(datadir, package, version, package, "DESCRIPTION", sep="/")
}

descfile.read <- function(version, package, datadir) {
  as.list(read.dcf(descfile.name(version, package, datadir))[1,])
}

descfiles.read.package <- function(package, datadir) {
  res <- lapply(package$versions, descfile.read, package$name, datadir)
  names(res) <- package$versions
  res
}

descfiles.read <- function(packages, datadir) {
  sapply(packages, descfile.read.package, datadir)
}

descfile.insert.keyvalue <- function(con, package, version, key, value) {
  key <- dbEscapeStrings(con, key)
  value <- dbEscapeStrings(con, value)
  query <- "INSERT INTO description_files (version_id, keyword, value) VALUES (%d, '%s', '%s')"
  query <- sprintf(query, version.get.id(con, package, version), key, value)
  dbClearResult(dbSendQuery(con, query))
}

descfile.insert <- function(con, package, version, descfile) {
  for(key in names(descfile)) {
    # TODO remove silent=TRUE
    # rather use tryCatch to print when there is an error other than duplicate
    try(descfile.insert.keyvalue(con, package, version, key, descfile[[key]]),
        silent=TRUE)
  }
}

descfiles.insert <- function(con, packages, descfiles) {
  for(package in names(packages)) {
    for(version in names(packages[[package]]$versions)) {
      descfile <- descfiles[[package]][[version]]
      descfile.insert(con, package, version, descfile)
    }
  }
}
