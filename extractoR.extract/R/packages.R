Duplicates <- function(packages) {
  packages[, if (.N > 1) list(package=unique(package)),
           by=c("source", "Package")]
}

Uniques <- function(packages) {
  packages[, if (.N == 1) list(package=unique(package)),
           by=c("source", "Package")]
}

PackagesMatchingRepository <- function(packages, tolower=FALSE) {
  repos <- ParseGithubRepositoryName(packages$package)$repository
  if (tolower) packages[tolower(Package) == tolower(repos)]
  else packages[Package == repos]
}

Packages <- function(descfiles, broken) {
  packages <- broken[TRUE & !is.broken, list(source, package, version)]
  keys <- c("Package", "Version", "Depends", "Imports", "Suggests",
            "Maintainer", "Author", "Date", "Packaged", "Date/Publication")
  names(keys) <- keys
  metadatas <- descfiles[key %in% keys]
  setkey(metadatas, source, package, version)
  metadatas <- dcast(metadatas[packages], source + package + version ~ key)
  packages <- unique(metadatas[, list(source, package, Package)])

  res <- Uniques(PackagesMatchingRepository(Duplicates(packages)))
  res <- rbind(Uniques(packages), res)
  res <- merge(res, metadatas, by=c("source", "package", "Package"))
  res[, c(list(source=source, package=package, version=version),
          lapply(keys, get, envir=environment()))]
}
