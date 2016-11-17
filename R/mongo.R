MissingEntries <- function(index, con) {
    fields <- list(source=1, repository=1, ref=1, "_id"=0)
    existing <- unique(con$find(fields=jsonlite::toJSON(fields, auto_unbox=TRUE)))
    if (nrow(existing)) {
        setkey(as.data.table(index), source, repository, ref)[!existing]
    } else as.data.table(index)
}
