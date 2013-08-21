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

maintainers.get <- function(con) {
  query <- paste("SELECT p.name package, v.version,",
                 "df.value people, \"maintainer\" role",
                 "FROM description_files df, packages p, package_versions v",
                 "WHERE v.package_id = p.id AND df.version_id = v.id",
                 "AND df.keyword = 'Maintainer'", sep=" ")
  dbGetQuery(con, query)
}

authors.get <- function(con) {
  query <- paste("SELECT p.name package, v.version,",
                 "df.value people, \"author\" role",
                 "FROM description_files df, packages p, package_versions v",
                 "WHERE v.package_id = p.id AND df.version_id = v.id",
                 "AND df.keyword = 'Author'", sep=" ")
  dbGetQuery(con, query)
}

person.get.id <- function(con, name, email) {
  name <- dbEscapeStrings(con, name)
  email <- dbEscapeStrings(con, email)
  query <- sprintf("SELECT id FROM people WHERE name = '%s' AND email = '%s'",
                   name, email)
  dbGetQuery(con, query)[1, 1]
}

role.exists <- function(con, name, email, package, version, role) {
  package <- dbEscapeStrings(con, package)
  version <- dbEscapeStrings(con, version)
  name <- dbEscapeStrings(con, name)
  email <- dbEscapeStrings(con, email)
  role <- dbEscapeStrings(con, role)
  query <- paste("SELECT COUNT(*)",
                 "FROM roles r, people per, packages p, package_versions v",
                 "WHERE p.name = '%s' AND v.version = '%s'",
                 "AND p.id = v.package_id AND v.id = r.version_id",
                 "AND per.id = r.person_id AND per.name = '%s'",
                 "AND per.email = '%s' AND r.role = '%s'")
  query <- sprintf(query, package, version, name, email, role)
  dbGetQuery(con, query)[1, 1] > 0
}
