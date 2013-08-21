library(RMySQL)

version.insert <- function(con, package, version) {
  version <- dbEscapeStrings(con, version)
  query <- "INSERT INTO package_versions (version, package_id) VALUES ('%s', %d)"
  query <- sprintf(query, version, package.get.id(con, package))
  dbClearResult(dbSendQuery(con, query))
  dbGetQuery(con, "SELECT LAST_INSERT_ID()")[1, 1]
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
