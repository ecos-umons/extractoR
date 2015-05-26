Extract <- function(datadir) {
  rdata <- list()

  rdata$packages <- readRDS(file.path(datadir, "rds", "packages.rds"))

  message("Reading description files")
  t <- system.time({
    rdata$descfiles <- CRANDescfiles(rdata$packages, datadir)
  })
  message(sprintf("Description files read in %.3fs", t[3]))

  message("Extracting broken packages")
  t <- system.time({
    rdata$borken <- BrokenPackages(rdata$descfiles)
  })
  message(sprintf("Broken packages extracted in %.3fs", t[3]))

  message("Extracting people")
  t <- system.time({
    rdata$roles <- ExtractRoles(rdata$descfiles, "maintainer")
    rdata$people <- unique(rdata$roles[, list(name, email)])
  })
  message(sprintf("People extracted in %.3fs", t[3]))

  message("Extracting dependencies")
  t <- system.time({
    rdata$deps <- rbind(ExtractDependencies(rdata$descfiles,
                                            c("Depends", "Depents", "%Depends",
                                              "Dependes", "Depens",
                                              "Dependencies", "DependsSplus",
                                              "DependsTERR")),
                        ExtractDependencies(rdata$descfiles,
                                            c("Imports", "#Imports", "Import")),
                        ExtractDependencies(rdata$descfiles,
                                            c("Suggests", "SUGGESTS",
                                              "suggests", "Suggets", "Suggest",
                                              "%Suggests", "Recommends")),
                        ExtractDependencies(rdata$descfiles,
                                            c("Enhances", "Enhanves")),
                        ExtractDependencies(rdata$descfiles,
                                            c("LinkingTo", "LinkingdTo")))
  })
  message(sprintf("Dependencies extracted in %.3fs", t[3]))

  message("Extracting dates and timeline")
  t <- system.time({
    rdata$dates <- rbind(ExtractDates(rdata$descfiles, "Packaged"),
                         ExtractDates(rdata$descfiles, "Date/Publication"),
                         ExtractDates(rdata$descfiles, "Date"))
    ## rdata$timeline <- rbind(ExtractTimeline(rdata$dates))
  })
  message(sprintf("Dates and timeline extracted in %.3fs", t[3]))

  message("Saving objects in data/rds")
  t <- system.time({
    SaveRData(rdata, datadir)
    SaveCSV(rdata, datadir)
  })
  message(sprintf("Objects saved in %.3fs", t[3]))
}
