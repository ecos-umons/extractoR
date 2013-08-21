library(RMySQL)


role.insert <- function(con, name, email, package, version, role) {
  role <- dbEscapeStrings(con, role)
  query <- sprintf(paste("INSERT INTO roles (version_id, person_id, role)",
                         "VALUES (%d, %d, '%s')"),
                   version.get.id(con, package, version),
                   person.get.id(con, name, email), role)
  dbClearResult(dbSendQuery(con, query))
}

role.ensure <- function(con, name, email, package, version, role) {
  if(!role.exists(con, name, email, package, version, role)) {
    insert.role(con, name, email, package, version, role)
  } else FALSE
}

roles.ensure <- function(role, con) {
  package <- role$package
  version <- role$version
  people <- role$people
  role <- role$role
  sapply(people, function(p)ensure.role(con, p$name, p$email,
                                        package, version, role))
}

roles.ensure.all <- function(con, people) {
  apply(people, 1, ensure.roles, con)
}
