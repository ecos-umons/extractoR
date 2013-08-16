library(RMySQL)

insert.package <- function(con, package) {
  name <- dbEscapeStrings(con, package$name)
  query <- sprintf("INSERT INTO packages (name) VALUES ('%s')", name)
  res <- dbSendQuery(con, query)
  dbClearResult(res)
  dbGetQuery(con, "SELECT LAST_INSERT_ID()")
}

get.package.id <- function(con, package) {
  name <- dbEscapeStrings(con, package$name)
  query <- sprintf("SELECT id FROM packages WHERE name = '%s'", name)
  dbGetQuery(con, query)
}

ensure.package <- function(package, con) {
  res <- get.package.id(con, package)
  if(!nrow(res)) {
    res <- insert.package(con, package)
  }
  id <- res[1,1]
  package$sql.id <- id
  package
}

ensure.packages <- function(con, packages) {
  lapply(packages, ensure.package, con)
}

insert.version <- function(con, package, version) {
  version <- dbEscapeStrings(con, version)
  query <- "INSERT INTO package_versions (version, package_id) VALUES ('%s', %d)"
  query <- sprintf(query, version, package$sql.id)
  res <- dbSendQuery(con, query)
  dbClearResult(res)
  dbGetQuery(con, "SELECT LAST_INSERT_ID()")
}

get.version.id <- function(con, package, version) {
  version <- dbEscapeStrings(con, version)
  query <- "SELECT id FROM package_versions WHERE package_id = %d AND version = '%s'"
  query <- sprintf(query, package$sql.id, version)
  dbGetQuery(con, query)
}

ensure.version <- function(version, package, con) {
  res <- get.version.id(con, package, version)
  if(!nrow(res)) {
    res <- insert.version(con, package, version)
  }
  id <- res[1,1]
  list(version=version, sql.id=id)
}

ensure.versions <- function(package, con) {
  versions <- lapply(package$versions, ensure.version, package, con)
  names(versions) <- package$versions
  package$versions <- versions
  package
}

ensure.all.versions <- function(con, packages) {
  lapply(packages, ensure.versions, con)
}

ensure.all.packages <- function(con, packages) {
  ensure.all.versions(con, ensure.packages(con, packages))
}

insert.descfile.key <- function(con, version, key, value) {
  key <- dbEscapeStrings(con, key)
  value <- dbEscapeStrings(con, value)
  query <- "INSERT INTO description_files (version_id, keyword, value) VALUES (%d, '%s', '%s')"
  query <- sprintf(query, version$sql.id, key, value)
  res <- dbSendQuery(con, query)
  dbClearResult(res)
}

insert.descfile <- function(con, version, descfile) {
  for(key in names(descfile)) {
    # TODO remove silent=TRUE
    # rather use tryCatch to print when there is an error other than duplicate
    try(insert.descfile.key(con, version, key, descfile[[key]]), silent=TRUE)
  }
}

insert.descfiles <- function(con, packages, descfiles) {
  for(package in packages) {
    for(version in package$versions) {
      descfile <- descfiles[[package$name]][[version$version]]
      insert.descfile(con, version, descfile)
    }
  }
}
