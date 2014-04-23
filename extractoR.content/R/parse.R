ParsePackage <- function(package, version, path, fcode, fnull, ferr,
                         guess.encoding=FALSE) {
  res <- tryCatch(CloneR::ParsePackage(path), error=function(e) e[[1]])
  data <- list(package=package, version=version, path=path)
  if (is.null(res)) {
    fnull(data)
  } else if (is.expression(res)) {
    data$code <- res
    fcode(data)
  } else if (!is.null(res)) {
    data$err <- res
    ferr(data)
  }
}
