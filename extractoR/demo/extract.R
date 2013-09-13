library(extractoR.fetch)
library(extractoR.extract)

packages.list <- LoadPackagesList("packages/packages.yml")
packages <- GetPackagesDataframe(packages.list)
rversions <- ExtractRversions(packages.list)

message("Reading description files")
t <- system.time({
  descfiles <- ReadDescfiles(packages, "packages")
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

message("Extracting dates")
t <- system.time({
  dates <- rbind(ExtractDates(descfiles, "Packaged"),
                 ExtractDates(descfiles, "Date/Publication"))
})
message(sprintf("Dates extracted in %.3fs", t[3]))

message("Saving objects in data/rds")
t <- system.time({
  tosave <- c("packages.list", "packages", "rversions", "descfiles", "roles",
              "people", "dependencies", "dates")
  sapply(tosave, SaveRData, "data/rds")
})
message(sprintf("Objects saved in %.3fs", t[3]))
