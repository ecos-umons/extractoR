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
  metadatas <- descfiles[key %in% c("Package", "Version")]
  setkey(metadatas, source, repository, ref)
  metadatas <- dcast(metadatas[packages], source + repository + ref ~ key)
  packages <- unique(metadatas[, list(source, repository, Package)])

  res <- Uniques(PackagesMatchingRepository(Duplicates(packages)))
  res <- rbind(Uniques(packages), res)
  res <- merge(res, metadatas, by=c("source", "repository", "Package"))
  setkey(res[, list(source, repository, ref, Package, Version)], NULL)
}
