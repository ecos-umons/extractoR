IsPackage <- function(descfile) {
  keys <- table(descfile$key)
  UniqueKey <- function(key) key %in% names(keys) && keys[key] == 1
  UniqueKey("Package") && UniqueKey("Version")
}

VersionWellFormatted <- function(descfile) {
  length(grep("\\d+[-.]\\d+([-.]\\d+)?", descfile[key == "Version"]$value)) > 0
}

DepsWellFormatted <- function(descfile) {
  deps <- descfile[key == "Depends" | key == "Imports", value]
  all(grepl(dependencies.re, deps))
}

BrokenPackages <- function(descfiles, packages) {
  res <- descfiles[, {
    logdebug("Checking if %s %s (%s) is broken", package,
             version, source, logger="extract.broken")
    list(is.package=IsPackage(.SD),
         version.well.formatted=VersionWellFormatted(.SD),
         deps.well.formatted=DepsWellFormatted(.SD),
         has.descfile=TRUE)
  }, by=c("source", "package", "version")]
  res <- setkey(res, source, package, version)[packages]
  res[is.na(has.descfile),
      c("is.package", "version.well.formatted",
        "deps.well.formatted", "has.descfile") := FALSE]
  res[, is.broken := !is.package | !deps.well.formatted]
  res
}
