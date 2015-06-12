ParseDate <- function(date) {
  IsValid <- function(date) {
    !is.na(date) & date >= as.POSIXlt("1970-01-01")
  }
  formats <- c("%Y-%m-%d %H:%M:%S", "%a %b %d %H:%M:%S %Y",
               "%Y-%m-%d", "%Y/%m/%d", "%d-%m-%Y", "%d/%m/%Y",
               "%d %B %Y", "%B %d, %Y", "%d %b %Y", "%b %d, %Y",
               "%d-%B-%Y", "%Y-%B-%d", "%d-%b-%Y", "%Y-%b-%d")
  for (f in formats) {
    d <- as.POSIXlt(date, format=f)
    if (IsValid(d)) {
      return(d)
    }
  }
  NA
}

ExtractDates <- function(descfiles, type) {
  # Extracts dates information from DESCRIPTION files.
  d <- descfiles[tolower(key) == tolower(type)]
  dates <- sapply(strsplit(d$value, ";"), function(x) strftime(ParseDate(x[1])))
  d[, list(source, repository, ref, type=tolower(type),
           date=dates)][!is.na(date)]
}

## ExtractTimeline <- function(dates) {
##   dates$date <- as.character(dates$date)
##   dates <- split(dates, paste(dates$package, dates$version))
##   dates <- lapply(dates, function(x) {
##     if ("date/publication" %in% x$type) {
##       if (any(x$type == "packaged")) {
##         x[x$type == "packaged", ]$date <- NA
##       }
##       if (any(x$type == "date")) {
##         x[x$type == "date", ]$date <- NA
##       }
##     } else if ("packaged" %in% x$type) {
##       if (any(x$type == "date")) {
##         x[x$type == "date", ]$date <- NA
##       }
##     }
##     x
##   })
##   dates <- FlattenDF(dates)
##   dates <- dates[!is.na(dates$date), ]
##   dates$type <- NULL
##   dates$date <- as.POSIXlt(dates$date)
##   dates
## }
