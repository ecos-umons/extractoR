\name{extractoR.extract-package}
\alias{extractoR.extract-package}
\alias{extractoR.extract}
\docType{package}
\encoding{UTF-8}
\title{CRAN packages metadata extractor (extract)}
\description{
  extractoR.extract is part of extractoR which is a set of R packages
  that can be used to fetch, extract and query CRAN packages metadata.
  extractoR.extract extracts packages metadata in data.tables objects.
}

\author{
Maëlick Claes <himself@maelick.net> & Prateek Rastogi <p.rastogi@outlook.com>

Maintainer: Maëlick Claes <himself@maelick.net>
}

\examples{
\dontrun{
library(extractoR.extract)

# Packages list got from FetchCRANList from extractoR.fetch
cran <- readRDS(file.path(pkgdir, "cran.rds"))
packages <- cran$packages
rversions <- cran$rversions

descfiles <- ReadDescfiles(packages, "packages")

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
sapply(tosave, SaveRData, "data/rds")
}
}