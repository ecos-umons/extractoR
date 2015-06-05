re <- "^([^:]+):([^:]+)(:([^:]+))?$"

ParseGithubRepositoryName <- function(str) {
  subdir <- sub(re, "\\4", str)
  subdir[subdir == ""] <- "."
  data.table(owner=sub(re, "\\1", str),
             repository=sub(re, "\\2", str), subdir=subdir)
}

ParseRepositoryId <- function(str) {
  data.table(source=sub(re, "\\1", str),
             repository=sub(re, "\\2", str),
             version=sub(re, "\\4", str))
}
