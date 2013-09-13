df.send.limit <- 1000

FormatString <- function(con, s) {
  sprintf("'%s'", dbEscapeStrings(con, s))
}

InsertDataFrameAll <- function(con, table, df) {
  MakeList <- function(l) do.call("paste", c(as.list(l), list(sep=", ")))
  columns <- MakeList(colnames(df))
  rows <- MakeList(apply(df, 1, function(r) sprintf("(%s)", MakeList(r))))
  query <- sprintf("INSERT IGNORE INTO %s (%s) VALUES %s",
                   table, columns, rows)
  dbClearResult(dbSendQuery(con, query))
}

InsertDataFrameSlice <- function(con, table, df) {
  for (i in 1:(ceiling(nrow(df) / df.send.limit))) {
    j <- i * df.send.limit
    i <- (i - 1) * df.send.limit + 1
    if (j > nrow(df)) {
      j <- nrow(df)
    }
    message(sprintf("Inserting rows %d to %d", i, j))
    InsertDataFrameAll(con, table, df[i:j, ])
  }
}

InsertDataFrame <- function(con, table, df) {
  if (nrow(df) > df.send.limit & ncol(df) > 1) {
    InsertDataFrameSlice(con, table, df)
  } else {
    InsertDataFrameAll(con, table, df)
  }
}
