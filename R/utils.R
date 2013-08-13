running.time <- function(func) {
  t1 <- proc.time()
  res = func()
  t2 <- proc.time()
  list(res=res, time=t2 - t1)
}
