InsertPackages <- function(con, packages) {
  packages <- unique(packages)
  message(sprintf("Inserting %d packages", length(packages)))
  packages <- FormatString(con, packages)
  packages <- data.frame(name=packages)
  InsertDataFrame(con, "packages", packages)
}

InsertVersions <- function(con, versions) {
  versions <- unique(versions)
  message(sprintf("Inserting %d package versions", nrow(versions)))
  packages <- GetHashPackages(con)
  packages <- sapply(versions$package, function(p) packages[[p]])
  mtimes <- sapply(FormatString(con, format(versions$mtime)),
                   function(x) if (is.na(x)) "NULL" else x)
  sizes <- sapply(versions$size, function(x) if (is.na(x)) "NULL" else x)
  versions <- data.frame(package_id=packages,
                         version=FormatString(con, versions$version),
                         mtime=mtimes, size=sizes)
  InsertDataFrame(con, "package_versions", versions)
}

InsertPeople <- function(con, people) {
  people <- unique(people)
  message(sprintf("Inserting %d people", nrow(people)))
  people$name <- FormatString(con, people$name)
  people$email <- FormatString(con, people$email)
  InsertDataFrame(con, "people", people)
}

InsertDescfiles <- function(con, descfiles) {
  descfiles <- unique(descfiles)
  message(sprintf("Inserting %d DESCRIPTION files", nrow(descfiles)))
  versions <- GetHashVersions(con)
  versions <- apply(descfiles, 1, function(v) versions[[GetVersionKey(v)]])
  keys <- FormatString(con, descfiles$key)
  values <- FormatString(con, as.character(descfiles$value))
  descfiles <- data.frame(version_id=versions, keyword=keys, value=values)
  InsertDataFrame(con, "description_files", descfiles)
}

InsertRoles <- function(con, roles) {
  roles <- unique(roles)
  message(sprintf("Inserting %d roles", nrow(roles)))
  versions <- GetHashVersions(con)
  versions <- apply(roles, 1, function(v) versions[[GetVersionKey(v)]])
  people <- GetHashPeople(con)
  people <- apply(roles, 1, function(p) people[[GetPersonKey(p)]])
  roles <- FormatString(con, roles$role)
  roles <- data.frame(version_id=versions, person_id=people, role=roles)
  InsertDataFrame(con, "roles", roles)
}

InsertDependencies <- function(con, dependencies) {
  dependencies <- unique(dependencies)
  message(sprintf("Inserting %d dependencies", nrow(dependencies)))
  versions <- GetHashVersions(con)
  versions <- apply(dependencies, 1, function(v) versions[[GetVersionKey(v)]])
  types <- FormatString(con, dependencies$type)
  dependencies <- FormatString(con, dependencies$dependency)
  dependencies <- data.frame(version_id=versions, dependency=dependencies,
                             type=types)
  InsertDataFrame(con, "package_dependencies", dependencies)
}

InsertDependencyConstraints <- function(con, constraints) {
  constraints <- unique(constraints[!is.na(constraints$constraint.type), ])
  message(sprintf("Inserting %d dependency constraints", nrow(constraints)))
  deps <- GetHashDependencies(con)
  deps <- apply(constraints, 1, function(c) deps[[GetDependencyKey(c)]])
  types <- FormatString(con, constraints$constraint.type)
  versions <- FormatString(con, constraints$constraint.version)
  constraints <- data.frame(dependency_id=deps, type=types, version=versions)
  InsertDataFrame(con, "dependency_constraints", constraints)
}

InsertDates <- function(con, dates) {
  dates <- unique(dates)
  message(sprintf("Inserting %d dates", nrow(dates)))
  versions <- GetHashVersions(con)
  versions <- apply(dates, 1, function(v) versions[[GetVersionKey(v)]])
  types <- FormatString(con, dates$type)
  dates <- FormatString(con, as.character(dates$date))
  dates <- data.frame(version_id=versions, type=types, date=dates)
  InsertDataFrame(con, "dates", dates)
}

InsertTimeline <- function(con, timeline) {
  dates <- unique(timeline)
  message(sprintf("Inserting %d timeline dates", nrow(dates)))
  versions <- GetHashVersions(con)
  versions <- apply(dates[c(1, 2)], 1, function(v) versions[[GetVersionKey(v)]])
  dates <- FormatString(con, as.character(dates$date))
  dates <- data.frame(version_id=versions, date=dates)
  InsertDataFrame(con, "packages_timeline", dates)
}
