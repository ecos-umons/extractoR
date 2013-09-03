ParseDate <- function(date) {
  try(return(as.POSIXlt(date)), silent=TRUE)
  as.POSIXlt(date, format="%a %b %d %H:%M:%S %Y")
}

ExtractDates <- function(descfiles, type, ParseDates) {
  d <- GetDescfilesKey(descfiles, type)
  dates <- sapply(strsplit(d$value, ";"), function(x) strftime(ParseDate(x[1])))
  data.frame(package=d$package, version=d$version,
             type=rep(tolower(type), nrow(d)),
             date=as.POSIXlt(dates),
             stringsAsFactors=FALSE)
}
