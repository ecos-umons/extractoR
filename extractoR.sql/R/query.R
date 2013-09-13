library(RMySQL)

GetPackages <- function(con) {
  dbGetQuery(con, "SELECT id, name FROM packages")
}

GetHashPackages <- function(con) {
  packages <- GetPackages(con)
  hash(packages$name, packages$id)
}

GetVersions <- function(con) {
  query <- paste("SELECT v.id, p.name package, v.version",
                 "FROM package_versions v, packages p",
                 "WHERE p.id = v.package_id")
  dbGetQuery(con, query)
}

GetVersionKey <- function(version) {
  paste(version["package"], version["version"])
}

GetHashVersions <- function(con) {
  versions <- GetVersions(con)
  hash(apply(versions, 1, GetVersionKey), versions$id)
}

GetPeople <- function(con) {
  dbGetQuery(con, "SELECT id, name, email FROM people")
}

GetPersonKey <- function(person) {
  sprintf("%s <%s>", person["name"], person["email"])
}

GetHashPeople <- function(con) {
  people <- GetPeople(con)
  hash(apply(people, 1, GetPersonKey), people$id)
}

GetDependencies <- function(con) {
  query <- paste("SELECT d.id, p.name package, v.version, d.dependency, d.type",
                 "FROM package_dependencies d, package_versions v, packages p",
                 "WHERE d.version_id = v.id AND v.package_id = p.id")
  dbGetQuery(con, query)
}

GetDependencyKey <- function(dependency) {
  paste(dependency["package"], dependency["version"],
        dependency["type"], dependency["dependency"])
}

GetHashDependencies <- function(con) {
  dependencies <- GetDependencies(con)
  hash(apply(dependencies, 1, GetDependencyKey), dependencies$id)
}
