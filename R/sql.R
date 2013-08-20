library(RMySQL)

package.insert <- function(con, package) {
  package <- dbEscapeStrings(con, package)
  query <- sprintf("INSERT INTO packages (name) VALUES ('%s')", package)
  dbClearResult(dbSendQuery(con, query))
  dbGetQuery(con, "SELECT LAST_INSERT_ID()")[1, 1]
}

package.get.id <- function(con, package) {
  package <- dbEscapeStrings(con, package)
  query <- sprintf("SELECT id FROM packages WHERE name = '%s'", package)
  dbGetQuery(con, query)[1, 1]
}

package.ensure <- function(package, con) {
  id <- package.get.id(con, package$name)
  if(is.null(id)) {
    id <- package.insert(con, package$name)
  }
  id
}

packages.ensure <- function(con, packages) {
  lapply(names(packages), package.ensure, con)
}

version.insert <- function(con, package, version) {
  version <- dbEscapeStrings(con, version)
  query <- "INSERT INTO package_versions (version, package_id) VALUES ('%s', %d)"
  query <- sprintf(query, version, package.get.id(con, package))
  dbClearResult(dbSendQuery(con, query))
  dbGetQuery(con, "SELECT LAST_INSERT_ID()")[1, 1]
}

version.get.id <- function(con, package, version) {
  package <- dbEscapeStrings(con, package)
  version <- dbEscapeStrings(con, version)
  query <- paste("SELECT v.id FROM package_versions v, packages p",
                 "WHERE p.name = '%s' AND p.id = v.package_id",
                 "AND v.version = '%s'")
  query <- sprintf(query, package, version)
  dbGetQuery(con, query)[1, 1]
}

version.ensure <- function(version, package, con) {
  id <- version.get.id(con, package, version)
  if(is.null(id)) {
    id <- version.insert(con, package, version)
  }
  id
}

versions.ensure <- function(package, con) {
  lapply(names(package$versions), version.ensure, package$name, con)
}

versions.ensure.all <- function(con, packages) {
  lapply(packages, versions.ensure, con)
}

descfile.insert.key <- function(con, package, version, key, value) {
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
    try(descfile.insert.key(con, package, version, key, descfile[[key]]),
        silent=TRUE)
  }
}

insert.descfiles <- function(con, packages, descfiles) {
  for(package in names(packages)) {
    for(version in names(packages[[package]]$versions)) {
      descfile <- descfiles[[package]][[version]]
      insert.descfile(con, package, version, descfile)
    }
  }
}

sql.load <- function(con) {
  query <- paste("SELECT p.name package, v.version FROM packages p, package_versions v",
                 "WHERE v.package_id = p.id", sep=" ")
  dbGetQuery(con, query)
}
