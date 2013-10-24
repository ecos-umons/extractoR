GetCRANStatus <- function(con, flavor) {
  query <- paste("SELECT s.date, p.name package, v.version version,",
                 "f.name flavor, mp.name maintainer, s.status",
                 "FROM package_versions v, packages p, flavors f,",
                 "identity_merging im, merged_people mp, cran_status s",
                 sprintf("WHERE f.name = '%s'", flavor),
                 "AND s.version_id = v.id AND v.package_id = p.id",
                 "AND s.maintainer_id = im.orig_id AND im.merged_id = mp.id",
                 "AND f.id = s.flavor_id",
                 "ORDER BY p.id, s.date")
  dbGetQuery(con, query)
}

AddArchived <- function(package, dates) {
  dates <- setdiff(dates, package$date)
  if (length(dates)) {
    archived <- data.frame(date=dates)
    archived$package <- package$package[1]
    archived$version <- ""
    archived$flavor <- package$flavor[1]
    archived$maintainer <- ""
    archived$status <- "ARCHIVED"
    package <- rbind(package, archived)
    package[with(package, order(date)), ]
  } else {
    package
  }
}

ExtractStatusChanges <- function(package) {
  p1 <- package[2:nrow(package), ]
  p2 <- package[1:(nrow(package) - 1), ]
  ExtractUpdates <- function(col) {
    updates <- p1[col] != p2[col]
    data.frame(date=p1$date[updates], package=p1$package[updates],
               type=rep(col, length(updates[updates])),
               old=p2[col][updates], new=p1[col][updates],
               stringsAsFactors=FALSE)
  }
  status <- ExtractUpdates("status")
  versions <- ExtractUpdates("version")
  maintainers <- ExtractUpdates("maintainer")
  archived <- status$date[status$old == "ARCHIVED" | status$new == "ARCHIVED"]
  res <- rbind(status, versions, maintainers)
  # Used to remove versions & maintainers changes when versions is
  # archived or unarchived. TODO maybe we don't want to loose this
  # information as a version can (or will surely?) change when a
  # package is first archived and then unarchived.
  ## res <- rbind(status, versions[!versions$date %in% archived, ],
  ##              maintainers[!maintainers$date %in% archived, ])
  res <- res[with(res, order(date, package)), ]
  res
}

ExtractPackagesStatusChanges <- function(packages) {
  dates <- sort(unique(packages$date))
  packages <- split(packages, packages$package)
  packages <- lapply(packages, AddArchived, dates)
  packages <- lapply(packages, ExtractStatusChanges)
  dflist2df(packages)
}

InsertChanges <- function(con, flavor, changes) {
  descfiles <- unique(changes)
  message(sprintf("Inserting %d status changes", nrow(changes)))
  packages <- GetHashPackages(con)
  packages <- sapply(changes$package, function(p) packages[[p]])
  flavors <- rep(GetHashFlavors(con)[[flavor]], nrow(changes))
  dates <- sprintf("'%s'", as.character(changes$date))
  types <- FormatString(con, changes$type)
  old <- FormatString(con, changes$old)
  new <- FormatString(con, changes$new)
  changes <- data.frame(flavor_id=flavors, date=dates, package_id=packages,
                        type=types, old=old, new=new)
  InsertDataFrame(con, "cran_changes", changes)
}

ExtractChanges <- function(con, flavor) {
  cran <- GetCRANStatus(con, flavor)
  dates <- sort(unique(cran$date))
  ExtractPackagesStatusChanges(cran)
}
