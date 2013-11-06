FormatString <- function(con, s) {
  # Formats character strings so they can be safely used in SQL
  # queries.
  #
  # Args:
  #   con: Connection object to the database.
  #   s: The character string to format.
  #
  # Returns:
  #   The character string formatted.
  sprintf("'%s'", dbEscapeStrings(con, s))
}

InsertDataFrameAll <- function(con, table, df) {
  # Insert a dataframe in a table all at once.
  #
  # Args:
  #   con: Connection object to the database.
  #   table: The name of the table to insert the dataframe in.
  #   df: The dataframe to insert.
  MakeList <- function(l) do.call("paste", c(as.list(l), list(sep=", ")))
  columns <- MakeList(colnames(df))
  rows <- MakeList(apply(df, 1, function(r) sprintf("(%s)", MakeList(r))))
  query <- sprintf("INSERT IGNORE INTO %s (%s) VALUES %s",
                   table, columns, rows)
  dbSendQuery(con, query)
}

InsertDataFrameSlice <- function(con, table, df, df.send.limit=1000) {
  # Insert a dataframe in a table slice by slice.
  #
  # Args:
  #   con: Connection object to the database.
  #   table: The name of the table to insert the dataframe in.
  #   df: The dataframe to insert.
  #   df.send.limit: The size of the dataframe slices to use.
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

InsertDataFrame <- function(con, table, df, df.send.limit=1000) {
  # Insert a dataframe. Inserts it slice by slice if its size is
  # graeter than a given limit.
  #
  # Args:
  #   con: Connection object to the database.
  #   table: The name of the table to insert the dataframe in.
  #   df: The dataframe to insert.
  #   df.send.limit: The size of the dataframe slices to use.
  if (nrow(df) > df.send.limit & ncol(df) > 1) {
    InsertDataFrameSlice(con, table, df)
  } else {
    InsertDataFrameAll(con, table, df)
  }
}
