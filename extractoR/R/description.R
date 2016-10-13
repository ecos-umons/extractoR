ExtractDescriptionFiles <- function(datadir, db="rdata", host="mongodb://localhost") {
  index <- mongo("index", db, host)$find()

  con <- mongo("description", db, host)
  message("Reading DESCRIPTION files")
  t <- system.time({
    descfiles <- Descfiles(MissingEntries(index, con), datadir)
  })
  message(sprintf("DESCRIPTION files read in %.3fs", t[3]))
  con$insert(descfiles)

  con <- mongo("dependencies", db, host)
  message("Extracting dependencies")
  t <- system.time({
    descfiles <- as.data.table(mongo("description", db, host)$find())
    missing <- MissingEntries(index, con)[, list(source, repository, ref)]
    missing <- setkey(descfiles, source, repository, ref)[missing]
    deps <- ExtractDependencies(missing, list("Depends", "Imports", "Suggests",
                                              "Enhances", "LinkingTo"))
  })
  message(sprintf("Dependencies extracted in %.3fs", t[3]))
  con$insert(deps)

  descfiles <- as.data.table(mongo("description", db, host)$find())

  con <- mongo("dependencies", db, host)
  message("Extracting dependencies")
  t <- system.time({
    missing <- MissingEntries(index, con)[, list(source, repository, ref)]
    missing <- setkey(descfiles, source, repository, ref)[missing]
    fields <- list("Depends", "Imports", "Suggests", "Enhances", "LinkingTo")
    ## fields <- list(c("Depends", "Depents", "%Depends", "Dependes", "Depens",
    ##                  "Dependencies", "DependsSplus", "DependsTERR"),
    ##                c("Imports", "#Imports", "Import"),
    ##                c("Suggests", "SUGGESTS", "suggests", "Suggets", "Suggest",
    ##                  "%Suggests", "Recommends"),
    ##                c("Enhances", "Enhanves"),
    ##                c("LinkingTo", "LinkingdTo"))
    deps <- ExtractDependencies(missing, fields)
  })
  message(sprintf("Dependencies extracted in %.3fs", t[3]))
  con$insert(deps)

  con <- mongo("roles", db, host)
  message("Extracting roles")
  t <- system.time({
    missing <- MissingEntries(index, con)[, list(source, repository, ref)]
    missing <- setkey(descfiles, source, repository, ref)[missing]
    roles <- ExtractRoles(descfiles, "maintainer")
  })
  message(sprintf("Roles extracted in %.3fs", t[3]))
  con$insert(roles)

  # TODO FIXME
  ## message("Extracting dates and timeline")
  ## t <- system.time({
  ##   rdata$dates <- rbind(ExtractDates(descfiles, "Packaged"),
  ##                        ExtractDates(descfiles, "Date/Publication"),
  ##                        ExtractDates(descfiles, "Date"))
  ## })
  ## message(sprintf("Dates and timeline extracted in %.3fs", t[3]))
}
