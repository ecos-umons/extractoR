re1 <- "^([^/]+)/([^/]+)(/(([^/]+)*))?$"
re2 <- "^([^:]+):([^:]+)(:([^:]+))?$"

ParseGithubRepositoryName <- function(str) {
  subdir <- sub(re1, "\\4", str)
  subdir[subdir == ""] <- "."
  data.table(owner=sub(re1, "\\1", str),
             repository=sub(re1, "\\2", str), subdir=subdir)
}

ParseRepositoryId <- function(str) {
  data.table(source=sub(re2, "\\1", str),
             repository=sub(re2, "\\2", str),
             version=sub(re2, "\\4", str))
}
