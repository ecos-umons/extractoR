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
