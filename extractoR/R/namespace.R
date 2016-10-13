ExtractNamespaceFiles <- function(datadir, db="rdata", host="mongodb://localhost") {
  index <- mongo("index", db, host)$find()

  con <- mongo("namespace", db, host)
  message("Reading namespace files")
  t <- system.time({
    namespace <- Namespaces(MissingEntries(index, con), datadir)
  })
  message(sprintf("Namespace files read in %.3fs", t[3]))
  con$insert(namespace)
}
