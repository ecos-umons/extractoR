running.time <- function(func) {
  t1 <- proc.time()
  res = func()
  t2 <- proc.time()
  list(res=res, time=t2 - t1)
}

rstrip <- function(s) {
  sub("[[:space:]]*$", "", s)
}

lstrip <- function(s) {
  sub("^[[:space:]]*", "", s)
}

strip <- function(s) {
  gsub("^[[:space:]]*|[[:space:]]*$", "", s)
}

archive.parse.name <- function(archive) {
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
