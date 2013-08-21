library(RMySQL)

package.insert <- function(con, package) {
  package <- dbEscapeStrings(con, package)
  query <- sprintf("INSERT INTO packages (name) VALUES ('%s')", package)
  dbClearResult(dbSendQuery(con, query))
  dbGetQuery(con, "SELECT LAST_INSERT_ID()")[1, 1]
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

sql.load <- function(con) {
  query <- paste("SELECT p.name package, v.version FROM packages p, package_versions v",
                 "WHERE v.package_id = p.id", sep=" ")
  dbGetQuery(con, query)
}
