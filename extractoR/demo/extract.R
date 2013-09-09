library(extractoR.fetch)
library(extractoR.extract)

packages.list <- LoadPackagesList("packages/packages.yml")
packages <- GetPackagesDataframe(packages.list)
rversions <- ExtractRversions(packages.list)

print("Reading description files")
t <- system.time({
  descfiles <- ReadDescfiles(packages, "packages")
})
print(sprintf("Description files read in %.3fs", t[3]))

print("Extracting people")
t <- system.time({
  roles <- rbind(ExtractRoles(descfiles, "Maintainer"),
                 ExtractRoles(descfiles, "Author"))
  people <- ExtractPeople(maintainers, authors)
})
print(sprintf("People extracted in %.3fs", t[3]))

print("Extracting dependencies")
t <- system.time({
  dependencies <- rbind(ExtractDependencies(descfiles, "Depends"),
                        ExtractDependencies(descfiles, "Imports"),
                        ExtractDependencies(descfiles, "Suggests"),
                        ExtractDependencies(descfiles, "Enhances"))
})
print(sprintf("Dependencies extracted in %.3fs", t[3]))

print("Extracting dates")
t <- system.time({
  dates <- rbind(ExtractDates(descfiles, "Packaged"),
                 ExtractDates(descfiles, "Date/Publication"))
})
print(sprintf("Dates extracted in %.3fs", t[3]))

print("Extracting checks")
t <- system.time({
  checks <- ReadChecks("checks")
})
print(sprintf("Checks extracted in %.3fs", t[3]))

print("Saving objects in data/rds")
t <- system.time({
  tosave <- c("packages.list", "packages", "rversions", "descfiles", "roles",
              "people", "dependencies", "dates", "checks")
  sapply(tosave, SaveRData, "data/rds")
})
print(sprintf("Objects saved in %.3fs", t[3]))
