library(extractoR.fetch)

mirror <- "http://cran.parentingamerica.com"

print("Fetching package list from CRAN")
t <- system.time(packages <- FetchCRANList(mirror))
print(sprintf("Package list fetched from CRAN in %.3fs", t[3]))

SavePackagesList(packages, "packages/packages.yml")
printf("Package list saved to packages/packages.yml")

printf("Downloading missing packages")
t <- system.time(res <- FetchPackages(packages, "packages", mirror))[3]
print("%n packages downloaded in %.3fs", length(res[res]), t[3])
