FetchAll <- function(datadir, cran.mirror="http://cran.r-project.org") {
  message("Fetching package list from CRAN")
  t <- system.time(packages <- FetchCRANList(cran.mirror))
  message(sprintf("Package list fetched from CRAN in %.3fs", t[3]))

  pkgdir <- file.path(datadir, "packages")
  SavePackagesList(packages, file.path(pkgdir, "packages.yml"))
  message("Package list saved to packages/packages.yml")

  message("Downloading missing packages")
  t <- system.time(res <- FetchPackages(packages, pkgdir, cran.mirror))[3]
  message("%n packages downloaded in %.3fs", length(res[res]), t[3])

  res
}

ExtractAll <- function(datadir) {
  pkgdir <- file.path(datadir, "packages")

  packages.list <- LoadPackagesList(file.path(pkgdir, "packages.yml"))
  packages <- GetPackagesDataframe(packages.list)
  rversions <- ExtractRversions(packages.list)

  message("Reading description files")
  t <- system.time({
    descfiles <- ReadDescfiles(packages, pkgdir)
  })
  message(sprintf("Description files read in %.3fs", t[3]))

  message("Extracting people")
  t <- system.time({
    roles <- rbind(ExtractRoles(descfiles, "Maintainer"),
                   ExtractRoles(descfiles, "Author"))
    people <- ExtractPeople(roles)
  })
  message(sprintf("People extracted in %.3fs", t[3]))

  message("Extracting dependencies")
  t <- system.time({
    dependencies <- rbind(ExtractDependencies(descfiles, "Depends"),
                          ExtractDependencies(descfiles, "Imports"),
                          ExtractDependencies(descfiles, "Suggests"),
                          ExtractDependencies(descfiles, "Enhances"))
  })
  message(sprintf("Dependencies extracted in %.3fs", t[3]))

  message("Extracting dates and timeline")
  t <- system.time({
    dates <- rbind(ExtractDates(descfiles, "Packaged"),
                   ExtractDates(descfiles, "Date/Publication"),
                   ExtractDates(descfiles, "Date"))
    timeline <- rbind(ExtractTimeline(dates))
  })
  message(sprintf("Dates and timeline extracted in %.3fs", t[3]))

  message("Saving objects in data/rds")
  t <- system.time({
    tosave <- c("packages.list", "packages", "rversions", "descfiles", "roles",
                "people", "dependencies", "dates", "timeline")
    sapply(tosave, SaveRData, file.path(datadir, "rds"))
  })
  message(sprintf("Objects saved in %.3fs", t[3]))
}

InsertAll <- function(con, rdata) {
  InsertRVersions(con, rdata$rversions)
  InsertPackages(con, rdata$packages$package)
  InsertVersions(con, rdata$packages)
  InsertDescfiles(con, rdata$descfiles)
  InsertDates(con, rdata$dates)
  InsertTimeline(con, rdata$timeline)
  InsertDependencies(con, rdata$dependencies)
  InsertDependencyConstraints(con, rdata$dependencies)
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
