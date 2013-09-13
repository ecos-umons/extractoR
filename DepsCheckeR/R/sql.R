InsertFlavors <- function(con, flavors) {
  flavors <- unique(flavors)
  message(sprintf("Inserting %d flavors", length(flavors)))
  flavors <- FormatString(con, unique(as.vector(flavors)))
  flavors <- data.frame(name=flavors)
  InsertDataFrame(con, "flavors", flavors)
}

GetFlavors <- function(con) {
  dbGetQuery(con, "SELECT id, name FROM flavors")
}

GetHashFlavors <- function(con) {
  flavors <- GetFlavors(con)
  hash(flavors$name, flavors$id)
}

InsertCRANStatus <- function(con, status) {
  InsertFlavors(con, unique(status$flavor))
  InsertPackages(con, unique(status$package))
  InsertVersions(con, unique(data.frame(package=status$package,
                                        version=status$version,
                                        stringsAsFactors=FALSE)))
  InsertPeople(con, unique(status[, c("name", "email")]))
  versions <- GetHashVersions(con)
  versions <- apply(status, 1, function(v) versions[[GetVersionKey(v)]])
  flavors <- GetHashFlavors(con)
  flavors <- sapply(as.vector(status$flavor), function(f) flavors[[f]])
  dates <- sprintf("'%s'", as.character(status$date))
  priorities <- FormatString(con, status$priority)
  maintainers <- GetHashPeople(con)
  maintainers <- apply(status, 1, function(m) maintainers[[GetPersonKey(m)]])
  df <- data.frame(date=dates, version_id=versions, flavor_id=flavors,
                   maintainer_id=maintainers, priority=priorities)
  InsertDataFrame(con, "cran_status", df)
}

GetCRANStatus <- function(con) {
  query <- paste("SELECT s.id, p.name package, v.version,",
                 "f.name flavor, s.date",
                 "FROM package_versions v, packages p,",
                 "flavors f, cran_status s",
                 "WHERE p.id = v.package_id AND v.id = s.version_id",
                 "AND f.id = s.flavor_id")
  dbGetQuery(con, query)
}

GetCRANStatusKey <- function(status) {
  paste(status["package"], status["version"], status["flavor"], status["date"])
}

GetHashCRANStatus <- function(con) {
  status <- GetCRANStatus(con)
  hash(apply(status, 1, GetCRANStatusKey), status$id)
}

InsertCRANChecking <- function(con, checking) {
  status <- GetHashCRANStatus(con)
  status <- apply(checking, 1, function(s) status[[GetCRANStatusKey(s)]])
  types <- FormatString(con, as.vector(checking$check))
  outputs <- FormatString(con, checking$output)
  df <- data.frame(status_id=status, type=types, output=outputs)
  InsertDataFrame(con, "cran_checking", df)
}
