CRANStatus <- function(con, date, flavor) {
  query <- paste("SELECT s.date, p.name package, v.version version, s.status",
                 "FROM package_versions v, packages p,",
                 "flavors f, cran_status s",
                 sprintf("WHERE f.name = '%s'", flavor),
                 "AND s.version_id = v.id AND v.package_id = p.id",
                 sprintf("AND f.id = s.flavor_id AND s.date = '%s'", date),
                 "ORDER BY p.id, s.date")
  dbGetQuery(con, query)
}

Missings <- function(cran, packages) {
  n <- length(packages)
  rbind(data.frame(date=rep(unique(cran$date), n),
                   package=packages, version=as.character(rep("", n)),
                   status=rep("ARCHIVED", n), stringsAsFactors=FALSE), cran)
}

DiffCol <- function(packages, col) {
  col1 <- paste0(col, ".x")
  col2 <- paste0(col, ".y")
  packages <- packages[packages[[col1]] != packages[[col2]],
                       c("date.y", "package", col1, col2)]
  if (nrow(packages)) {
    names(packages) <- c("date", "package", "old", "new")
    packages$type <- col
    packages
  }
}

DiffStatus <- function(prev, current) {
  packages <- merge(Missings(prev, setdiff(current$package, prev$package)),
                    Missings(current, setdiff(prev$package, current$package)),
                    by="package")
  rbind(DiffCol(packages, "version"),
        DiffCol(packages, "status"))
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

ExtractAndInsertFlavorChanges <- function(con, flavor, from.date="1970-01-01",
                                          to.date=NA) {
  dates <- dbGetQuery(con, "SELECT DISTINCT date FROM cran_status")$date
  dates <- dates[dates >= as.POSIXlt(from.date) &
                 (is.na(to.date) | dates < as.POSIXlt(to.date))]
  prev <- CRANStatus(con, dates[1], flavor)
  for (date in dates[-1]) {
    message(sprintf("Inserting changes for date %s", date))
    cran <- CRANStatus(con, date, flavor)
    res <- DiffStatus(prev, cran)
    if (!is.null(res)) {
      InsertChanges(con, flavor, res)
    }
    prev <- cran
  }
}
