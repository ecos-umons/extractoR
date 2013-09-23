FetchAll <- function(datadir, cran.mirror="http://cran.r-project.org") {
  packages <- FetchCRANList(cran.mirror)
  pkgdir <- file.path(datadir, "packages")
  SavePackagesList(packages, file.path(pkgdir, "packages.yml"))
  FetchPackages(packages, pkgdir, cran.mirror)
}

ExtractAll <- function(datadir) {
  pkgdir <- file.path(datadir, "packages")
  packages.list <- LoadPackagesList(file.path(pkgdir, "packages.yml"))
  packages <- GetPackagesDataframe(packages.list)
  rversions <- ExtractRversions(packages.list)

  descfiles <- ReadDescfiles(packages, pkgdir)

  roles <- rbind(ExtractRoles(descfiles, "Maintainer"),
                 ExtractRoles(descfiles, "Author"))
  people <- ExtractPeople(roles)

  dependencies <- rbind(ExtractDependencies(descfiles, "Depends"),
                        ExtractDependencies(descfiles, "Imports"),
                        ExtractDependencies(descfiles, "Suggests"),
                        ExtractDependencies(descfiles, "Enhances"))

  dates <- rbind(ExtractDates(descfiles, "Packaged"),
                 ExtractDates(descfiles, "Date/Publication"))

  tosave <- c("packages.list", "packages", "rversions", "descfiles", "roles",
              "people", "dependencies", "dates")
  sapply(tosave, SaveRData, file.path(datadir, "rds"))
}

InsertAll <- function(con, rdata) {
  InsertRVersions(con, rdata$rversions)
  InsertPackages(con, rdata$packages$package)
  InsertVersions(con, rdata$packages)
  InsertDescfiles(con, rdata$descfiles)
  InsertDates(con, rdata$dates)
  InsertDependencies(con, rdata$dependencies)
  InsertDependencyConstraints(con, rdata$dependencies)
  InsertPeople(con, rdata$people)
  InsertRoles(con, rdata$roles)
}

ExtractInsertTaskViews <- function(con, cran.mirror="http://cran.r-project.org")
  ctv <- GetTaskViewsDataframe()
  ctv.content <- GetTaskViewsContent()
  InsertTaskViews(con, ctv[, c("taskview", "topic")])
  InsertPeople(con, ctv[, c("name", "email")])
  InsertTaskViewVersions(con, ctv)
}
