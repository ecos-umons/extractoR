Duplicates <- function(packages) {
  packages[, if (.N > 1) list(repository=unique(repository)),
           by=c("source", "Package")]
}

Uniques <- function(packages) {
  packages[, if (.N == 1) list(repository=unique(repository)),
           by=c("source", "Package")]
}

PackagesMatchingRepository <- function(packages, tolower=FALSE) {
  repos <- ParseGithubRepositoryName(packages$repository)$repository
  if (tolower) packages[tolower(Package) == tolower(repos)]
  else packages[Package == repos]
}

Packages <- function(descfiles, broken) {
  packages <- broken[TRUE & !is.broken, list(source, repository, ref)]
  keys <- c("Package", "Version", "Depends", "Imports", "Suggests",
            "Maintainer", "Author", "Date", "Packaged", "Date/Publication")
  names(keys) <- keys
  metadatas <- descfiles[key %in% keys]
  setkey(metadatas, source, repository, ref)
  metadatas <- dcast(metadatas[packages], source + repository + ref ~ key)
  packages <- unique(metadatas[, list(source, repository, Package)])

  res <- Uniques(PackagesMatchingRepository(Duplicates(packages)))
  res <- rbind(Uniques(packages), res)
  res <- merge(res, metadatas, by=c("source", "repository", "Package"))
  res[, c(list(source=source, repository=repository, ref=ref),
          lapply(keys, get, envir=environment()))]
}
