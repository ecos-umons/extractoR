RStrip <- function(s) {
  sub("[[:space:]]*$", "", s)
}

LStrip <- function(s) {
  sub("^[[:space:]]*", "", s)
}

Strip <- function(s) {
  gsub("^[[:space:]]*|[[:space:]]*$", "", s)
}

ParseArchiveName <- function(archive) {
  archive <- strsplit(archive, "_")[[1]]
  list(package=archive[1], version=strsplit(archive[2], "\\.tar\\.gz")[[1]][1])
}

dflist2df <- function(l, names) {
  m <- t(matrix(unlist(sapply(Filter(is.data.frame, l), t)),
                nrow=length(names)))
  df <- data.frame(m, stringsAsFactors=FALSE)
  colnames(df) <- names
  df
}
