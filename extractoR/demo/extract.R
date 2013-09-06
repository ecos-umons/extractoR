library(extractoR.fetch)
library(extractoR.extract)

packages <- LoadPackagesList("packages/packages.yml")
df <- GetPackagesDataframe(packages)
rversions <- ExtractRversions(packages)

print("Reading description files")
t <- system.time(descfiles <- ReadDescfiles(df, "packages"))
print(sprintf("Description files read in %.3fs", t[3]))

print("Extracting people")
t <- system.time({
  maintainers <- ExtractRoles(descfiles, "Maintainer")
  authors <- ExtractRoles(descfiles, "Author")
  people <- ExtractPeople(maintainers, authors)
})
print(sprintf("People extracted in %.3fs", t[3]))

print("Extracting dependencies")
t <- system.time({
  depends <- ExtractDependencies(descfiles, "Depends")
  imports <- ExtractDependencies(descfiles, "Imports")
  suggests <- ExtractDependencies(descfiles, "Suggests")
  enhances <- ExtractDependencies(descfiles, "Enhances")
})
print(sprintf("Dependencies extracted in %.3fs", t[3]))

print("Extracting dates")
t <- system.time({
  packaged <- ExtractDates(descfiles, "Packaged")
  publication <- ExtractDates(descfiles, "Date/Publication")
})
print(sprintf("Dates extracted in %.3fs", t[3]))

print("Extracting checks")
t <- system.time({
  details <- ReadChecks("details", "checks")
  flavors <- ReadChecks("flavors", "checks")
  results <- ReadChecks("results", "checks")
})
print(sprintf("Checks extracted in %.3fs", t[3]))

print("Saving objects in data/rds")
t <- system.time({
  dir.create("data/rds", recursive=TRUE)
  sapply(ls(), function(x) saveRDS(get(x), file=file.path("data/rds",
                                             sprintf("%s.rds", x))))
})
print(sprintf("Objects saved in %.3fs", t[3]))
