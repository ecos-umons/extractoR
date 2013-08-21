library(RMySQL)

descfile.get.keys <- function(con, package, version) {
  package <- dbEscapeStrings(con, package)
  version <- dbEscapeStrings(con, version)
  query <- paste("SELECT keyword",
                 "FROM description_files df, packages p, package_versions v",
                 "WHERE p.name = '%s' AND v.package_id = p.id",
                 "AND v.version = '%s' AND df.version_id = v.id")
  dbGetQuery(con, sprintf(query, package, version))[, 1]
}

descfile.get.value <- function(con, package, version, key) {
  package <- dbEscapeStrings(con, package)
  version <- dbEscapeStrings(con, version)
  key <- dbEscapeStrings(con, key)
  query <- paste("SELECT df.value",
                 "FROM description_files df, packages p, package_versions v",
                 "WHERE p.name = '%s' AND v.package_id = p.id",
                 "AND v.version = '%s' AND df.version_id = v.id",
                 "AND df.keyword = '%s'", sep=" ")
  dbGetQuery(con, sprintf(query, package, version, key))[1, 1]
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

package.get.id <- function(con, package) {
  package <- dbEscapeStrings(con, package)
  query <- sprintf("SELECT id FROM packages WHERE name = '%s'", package)
  dbGetQuery(con, query)[1, 1]
}
