pkgname.re <- "([[:alpha:]][[:alnum:].]*)"
version.re <- "[-[:digit:].]+"
constraint.re <- sprintf("[(][>=<]=?[[:space:]]*(%s)[)]", version.re)
dependency.re <- sprintf("%s([[:space:]]*%s)?", pkgname.re, constraint.re)
dependencies.re <- "^[[:space:]]*((%s)([[:space:]]*,[[:space:]]*%s)*,?)?$"
dependencies.re <- sprintf(dependencies.re, dependency.re, dependency.re)

IsPackage <- function(descfile) {
  keys <- table(descfile$key)
  UniqueKey <- function(key) key %in% names(keys) && keys[key] == 1
  UniqueKey("Package") && UniqueKey("Version")
}

PackageWellFormatted <- function(descfile) {
  grepl("^[-._[:alnum:]]+$", descfile[key == "Package", value])
}

VersionWellFormatted <- function(descfile) {
  grepl("^\\d+([-.]\\d+)*", descfile[key == "Version", value])
}

DepsWellFormatted <- function(descfile) {
  deps <- descfile[key == "Depends" | key == "Imports", value]
  all(grepl(dependencies.re, deps))
}

BrokenPackages <- function(descfiles, index) {
  res <- descfiles[, {
    logdebug("Checking if %s %s (%s) is broken", repository,
             ref, source, logger="extract.broken")
    list(is.package=IsPackage(.SD),
         package.well.formatted=PackageWellFormatted(.SD),
         version.well.formatted=VersionWellFormatted(.SD),
         deps.well.formatted=DepsWellFormatted(.SD),
         has.descfile=TRUE)
  }, by=c("source", "repository", "ref")]
  res <- setkey(res, source, repository, ref)[index]
  res[is.na(has.descfile),
      c("is.package", "version.well.formatted",
        "deps.well.formatted", "has.descfile") := FALSE]
  res[, is.broken := (!has.descfile | !is.package |
                      !package.well.formatted | !version.well.formatted |
                      !deps.well.formatted)]
  res
}
