Packages <- function(index, descfile.con, namespace.con) {
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

  PackageWellFormatted <- function(str) {
    grepl("^[-._[:alnum:]]+$", str)
  }

  VersionWellFormatted <- function(str) {
    grepl("^\\d+([-.]\\d+)*", str)
  }

  DepsWellFormatted <- function(descfile) {
    deps <- descfile[key == "Depends" | key == "Imports", value]
    all(grepl(dependencies.re, deps))
  }

  res <- rbindlist(mapply(function(source, repository, ref) {
    loginfo("Checking whether %s %s (%s) DESCRIPTION file is broken",
            repository, ref, source, logger="extract.broken")
    query <- jsonlite::toJSON(list(source=source, repository=repository, ref=ref),
                              auto_unbox=TRUE)
    descfile <- as.data.table(descfile.con$find(query))
    namespace <- namespace.con$count(query)

    if (nrow(descfile) > 0 && IsPackage(descfile)) {
      package <- descfile[key == "Package", value]
      version <- descfile[key == "Version", value]
      data.table(source, repository, ref, package, version, has.descfile=TRUE,
                 package.well.formatted=PackageWellFormatted(package),
                 version.well.formatted=VersionWellFormatted(version),
                 deps.well.formatted=DepsWellFormatted(descfile),
                 has.namespace=namespace > 0)
    } else {
      data.table(source, repository, ref,
                 package=NA, version=NA, has.descfile=FALSE,
                 package.well.formatted=FALSE, version.well.formatted=FALSE,
                 deps.well.formatted=FALSE, has.namespace=namespace > 0)
    }
  }, index$source, index$repository, index$ref, SIMPLIFY=FALSE))
  if (nrow(res)) {
    res[, is.broken := (!has.descfile | is.na(package) | is.na(version) |
                        !package.well.formatted | !version.well.formatted |
                        !deps.well.formatted)]
    res
  }
}

ExtractPackages <- function(db="rdata", host="mongodb://localhost") {
  index <- mongo("index", db, host)$find()
  descfile.con <- mongo("description", db, host, verbose=FALSE)
  namespace.con <- mongo("namespace", db, host, verbose=FALSE)

  con <- mongo("packages", db, host)
  todo <- MissingEntries(index, con)
  message("Extracting packages")
  t <- system.time({
    for(todo in split(todo, (1:nrow(todo) - 1) %/% 100)) {
      broken <- Packages(todo, descfile.con, namespace.con)
      if (!is.null(broken) && nrow(broken)) {
        con$insert(broken)
      }
    }
  })
  message(sprintf("Packages extracted in %.3fs", t[3]))
}

## Duplicates <- function(packages) {
##   packages[, if (.N > 1) list(repository=unique(repository)),
##            by=c("source", "package")]
## }

## Uniques <- function(packages) {
##   packages[, if (.N == 1) list(repository=unique(repository)),
##            by=c("source", "package")]
## }

## PackagesMatchingRepository <- function(packages, tolower=FALSE) {
##   repos <- ParseGithubRepositoryName(packages$repository)$repository
##   if (tolower) packages[tolower(package) == tolower(repos)]
##   else packages[package == repos]
## }

## FilterPackages <- function(packages) {
##   # FIXME
##   packages <- broken[TRUE & !is.broken, list(source, repository, ref)]
##   metadatas <- descfiles[key %in% c("Package", "Version")]
##   setkey(metadatas, source, repository, ref)
##   metadatas <- dcast(metadatas[packages], source + repository + ref ~ key)
##   packages <- unique(metadatas[, list(source, repository, package)])

##   res <- Uniques(PackagesMatchingRepository(Duplicates(packages)))
##   res <- rbind(Uniques(packages), res)
##   res <- merge(res, metadatas, by=c("source", "repository", "package"))
##   setkey(res[, list(source, repository, ref, package, version)], NULL)
## }
