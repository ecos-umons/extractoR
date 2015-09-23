ListCheckings <- function(checkdir) {
  # Lists available checking RDS files.
  res <- grep("\\d\\d(-\\d\\d){4}", dir(checkdir), value=TRUE)
  res <- res[file.exists(file.path(checkdir, res, "check_results.rds"))]
  names(res) <- as.character(strptime(res, format="%y-%m-%d-%H-%M"))
  data.table(date=names(res), dir=res)
}

ExtractMaintainers <- function(maintainers) {
  # Extracts maintainer names from a character vector of well formated
  # maintainers field.
  re <- "^(.*>)[^[:alpha:]]*([[:alpha:]].*)$"
  multi <- grep(re, maintainers)
  maintainers[multi] <- sapply(strsplit(gsub(re, "\\1|\\2", maintainers[multi]),
                                        "[|]"), function(x) x[1])
  maintainer.re <- "^\\s*(.*)\\s*<\\s*(.*@.*)\\s*>$"
  errors <- grep(maintainer.re, maintainers, invert=TRUE)
  names <- sub(maintainer.re, "\\1", maintainers)
  emails <- sub(maintainer.re, "\\2", maintainers)
  names[is.na(names)] <- ""
  emails[errors] <- ""
  list(names=names, emails=emails)
}

ReadChecking <- function(date, dir, filename, checkdir,
                         extract.maintainer=FALSE) {
  # Reads checking result RDS files.
  filepath <- file.path(checkdir, dir, filename)
  res <- as.data.table(readRDS(filepath))
  res$date <- date
  setnames(res, names(res), tolower(names(res)))
  if ("priority" %in% names(res)) {
    res[is.na(res$priority), priority := "contributed"]
  }
  if (extract.maintainer & "maintainer" %in% names(res)) {
    maintainers <- ExtractMaintainers(res$maintainer)
    res$name <- maintainers$maintainer.name
    res$email <- maintainers$maintainer.email
  }
  res
}

ConvertCSV <- function(checks, datadir) {
  checkdir <- file.path(datadir, "cran", "checks")
  mapply(function(date, dir) {
    output <- file.path(datadir, "cran", "snapshots", sprintf("%s.csv", date))
    if (!file.exists(output)) {
      loginfo("Converting CRAN check %s to CSV", date)
      write.csv(ReadChecking(date, dir, "check_results.rds", checkdir),
                file=output, row.names=FALSE)
      TRUE
    } else FALSE
  }, checks$date, checks$dir)
}

SnapshotIndex <- function(datadir, Subset, remove.duplicates=FALSE) {
  date.re <- "\\d\\d(-\\d\\d){2} \\d\\d(:\\d\\d){2}"
  files <- dir(file.path(datadir, "cran", "snapshots"),
               pattern=sprintf("%s\\.csv$", date.re))
  if (remove.duplicates) files <- files[!duplicated(as.Date(files))]
  lapply(files, function(f) {
    loginfo("read CRAN check %s", f)
    snapshot <- fread(file.path(datadir, "cran", "snapshots", f))
    Subset(snapshot)
  })
}

CRANCheckHistory <- function(datadir, flv="r-release-linux-x86_64",
                             remove.duplicates=FALSE) {
  res <- rbindlist(SnapshotIndex(datadir, function(snapshot) {
    snapshot[flavor == flv, list(date, package, version, status)]
  }, remove.duplicates))
  SaveCSV(list("check-history"=res), file.path(datadir, "cran"))
  res
}

FlavorHistory <- function(datadir, remove.duplicates=FALSE) {
  res <- rbindlist(SnapshotIndex(datadir, function(snapshot) {
    date <- snapshot$date[1]
    flavors <- table(snapshot$flavor)
    data.table(date, flavor=names(flavors), packages=as.integer(flavors))
  }, remove.duplicates))
  SaveCSV(list("flavor-history"=res), file.path(datadir, "cran"))
  res
}
