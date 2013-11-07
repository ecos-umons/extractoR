FetchAll <- function(datadir, cran.mirror="http://cran.r-project.org") {
  message("Fetching CRAN list")
  t <- system.time(cran <- FetchCRANList(cran.mirror))
  message(sprintf("CRAN list fetched from CRAN in %.3fs", t[3]))

  pkgdir <- file.path(datadir, "packages")
  saveRDS(cran, file.path(pkgdir, "cran.rds"))
  message("CRAN list saved to packages/cran.rds")

  message("Downloading missing packages")
  t <- system.time(res <- FetchPackages(cran, pkgdir, cran.mirror))
  message(sprintf("%d packages downloaded in %.3fs", length(res[res]), t[3]))
}

ExtractAll <- function(datadir) {
  pkgdir <- file.path(datadir, "packages")

  rdata <- list()

  rdata$cran <- readRDS(file.path(pkgdir, "cran.rds"))
  rdata$packages <- rdata$cran$packages
  rdata$rversions <- rdata$cran$rversions

  message("Reading description files")
  t <- system.time({
    rdata$descfiles <- ReadDescfiles(rdata$packages, pkgdir)
  })
  message(sprintf("Description files read in %.3fs", t[3]))

  message("Extracting people")
  t <- system.time({
    rdata$roles <- rbind(ExtractRoles(rdata$descfiles, "Maintainer"),
                         ExtractRoles(rdata$descfiles, "Author"))
    rdata$people <- ExtractPeople(rdata$roles)
  })
  message(sprintf("People extracted in %.3fs", t[3]))

  message("Extracting dependencies")
  t <- system.time({
    rdata$deps <- rbind(ExtractDependencies(rdata$descfiles, "Depends"),
                        ExtractDependencies(rdata$descfiles, "Imports"),
                        ExtractDependencies(rdata$descfiles, "Suggests"),
                        ExtractDependencies(rdata$descfiles, "Enhances"))
  })
  message(sprintf("Dependencies extracted in %.3fs", t[3]))

  message("Extracting dates and timeline")
  t <- system.time({
    rdata$dates <- rbind(ExtractDates(rdata$descfiles, "Packaged"),
                         ExtractDates(rdata$descfiles, "Date/Publication"),
                         ExtractDates(rdata$descfiles, "Date"))
    rdata$timeline <- rbind(ExtractTimeline(rdata$dates))
  })
  message(sprintf("Dates and timeline extracted in %.3fs", t[3]))

  message("Saving objects in data/rds")
  t <- system.time({
    SaveRData(rdata, file.path(datadir, "rds"))
  })
  message(sprintf("Objects saved in %.3fs", t[3]))
}

InsertAll <- function(con, rdata) {
  InsertPackages(con, rdata$packages$package)
  InsertVersions(con, rdata$packages)
  InsertDescfiles(con, rdata$descfiles)
  InsertDates(con, rdata$dates)
  InsertTimeline(con, rdata$timeline)
  InsertDependencies(con, rdata$deps)
  InsertDependencyConstraints(con, rdata$deps)
  InsertPeople(con, rdata$people)
  InsertRoles(con, rdata$roles)
}

UpdateTaskViews <- function(con, cran.mirror="http://cran.r-project.org") {
  ctv <- GetTaskViewsDataframe()
  ctv.content <- GetTaskViewsContent()
  InsertTaskViews(con, ctv[, c("taskview", "topic")])
  InsertPeople(con, ctv[, c("name", "email")])
  InsertTaskViewVersions(con, ctv)
}

ExtractAndInsertStatus <- function(con, checkdir, from.date="1970-01-01",
                                   to.date=NA) {
  # Extracts CRAN status and checkings and inserts them into a database.
  #
  # Args:
  #   con: The database connection object.
  #   checkdir: Root dir where all checking files are stored.
  #   from.date: Oldest checking to read.
  #   to.date: Newest checkings to read.
  for (date in ListCheckings(checkdir, from.date, to.date)) {
    status <- ReadCheckings(date, "check_results.rds", checkdir)
    checkings <- ReadCheckings(date, "check_details.rds", checkdir)
    message(sprintf("Inserting CRAN status %s", date))
    InsertCRANStatus(con, ExtractStatus(status, checkings))
  }
}

ExtractAndInsertChanges <- function(con) {
  flavors <- dbGetQuery(con, "SELECT name FROM flavors")$name
  flavors <- flavors[grep("linux-ix86", flavors, invert=TRUE)]

  for (flavor in flavors) {
    message(sprintf("Extracting changes for flavor %s", flavor))
    changes <- ExtractChanges(con, flavor)
    InsertChanges(con, flavor, changes)
  }
}
