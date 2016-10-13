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

Packages <- function(index, descfile.con, namespace.con) {
  res <- rbindlist(mapply(function(source, repository, ref) {
    logdebug("Checking if %s %s (%s) DESCRIPTION file is broken", repository,
             ref, source, logger="extract.broken")
    query <- toJSON(list(source=source, repository=repository, ref=ref),
                    auto_unbox=TRUE)
    descfile <- as.data.table(descfile.con$find(query=query))
    has.namespace <- descfile.con$count(query=query)

    if (nrow(descfile) > 0 && IsPackage(descfile)) {
      data.table(package=descfile[key == "Package", value],
                 version=descfile[key == "Version", value], has.descfile=TRUE,
                 package.well.formatted=PackageWellFormatted(descfile),
                 version.well.formatted=VersionWellFormatted(descfile),
                 deps.well.formatted=DepsWellFormatted(descfile),
                 has.namespace=has.namespace)
    } else {
      data.table(package=NA, version=NA, has.descfile=FALSE,
                 package.well.formatted=FALSE, version.well.formatted=FALSE,
                 deps.well.formatted=FALSE, has.namespace=has.namespace)
    }
  }, index$source, index$repository, index$ref, SIMPLIFY=FALSE))
  res[, is.broken := (!has.descfile | !is.na(package) | !is.na(version) |
                      !package.well.formatted | !version.well.formatted |
                      !deps.well.formatted)]
  res
}

Duplicates <- function(packages) {
  packages[, if (.N > 1) list(repository=unique(repository)),
           by=c("source", "package")]
}

Uniques <- function(packages) {
  packages[, if (.N == 1) list(repository=unique(repository)),
           by=c("source", "package")]
}

PackagesMatchingRepository <- function(packages, tolower=FALSE) {
  repos <- ParseGithubRepositoryName(packages$repository)$repository
  if (tolower) packages[tolower(package) == tolower(repos)]
  else packages[package == repos]
}

FilterPackages <- function(packages) {
  # FIXME
  packages <- broken[TRUE & !is.broken, list(source, repository, ref)]
  metadatas <- descfiles[key %in% c("Package", "Version")]
  setkey(metadatas, source, repository, ref)
  metadatas <- dcast(metadatas[packages], source + repository + ref ~ key)
  packages <- unique(metadatas[, list(source, repository, package)])

  res <- Uniques(PackagesMatchingRepository(Duplicates(packages)))
  res <- rbind(Uniques(packages), res)
  res <- merge(res, metadatas, by=c("source", "repository", "package"))
  setkey(res[, list(source, repository, ref, package, version)], NULL)
}
