source("scripts/main.R")
source("scripts/sql.R")

logs <- FetchLogsList("http://cran-logs.rstudio.com")
DownloadMissingLogs(logs, "data")
