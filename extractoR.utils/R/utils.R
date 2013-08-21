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
