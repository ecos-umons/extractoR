\name{InsertDataFrame}
\alias{InsertDataFrame}
\alias{InsertDataFrameAll}
\alias{InsertDataFrameSlice}
\encoding{UTF-8}
\title{InsertDataFrame}
\description{
  Functions used to insert dataframes into SQL tables.
}

\usage{
InsertDataFrameAll(con, table, df)
InsertDataFrameSlice(con, table, df, df.send.limit=1000)
InsertDataFrame(con, table, df, df.send.limit=1000)
}
\arguments{
  \item{con}{Connection object to the database.}
  \item{table}{The name of the table to insert the dataframe in.}
  \item{df}{The dataframe to insert.}
  \item{df.send.limit}{The size of the dataframe slices to use.}
}
\details{
  \code{InsertDataFrameAll} inserts a dataframe all at once in a single
  INSERT query.

  \code{InsertDataFrameSlice} inserts a dataframe using many
  subdataframes (slices). Size of the slices is specified with
  \code{df.send.limit}.

  \code{InsertDataFrame} chooses to use either \code{InsertDataFrameAll}
  or \code{InsertDataFrameSlice} depending wether the data frame has
  more than one column and exceeds the size limit.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{insert}
\keyword{dataframe}
\keyword{sql}
