source("scripts/main.R")
source("scripts/sql.R")

logs <- FetchLogsList("http://cran-logs.rstudio.com")
DownloadMissingLogs(logs, "data")

ExtractAndInsertLogs(con, "data", "2013-09-01")
