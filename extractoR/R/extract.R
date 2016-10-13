ExtractPackages <- function(datadir, db="rdata", host="mongodb://localhost") {
  index <- mongo("index", db, host)$find()
  descfile.con <- mongo("description", db, host)
  namespace.con <- mongo("namespace", db, host)

  message("Extracting packages")
  t <- system.time({
    broken <- Packages(index, descfile.con, namespace.con)
  })
  message(sprintf("Packages extracted in %.3fs", t[3]))
    con <- mongo("packages", db, host)$insert(packages)
}
