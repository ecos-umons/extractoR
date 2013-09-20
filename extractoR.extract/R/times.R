ParseDate <- function(date) {
  # Parses a date
  try(return(as.POSIXlt(date)), silent=TRUE)
  as.POSIXlt(date, format="%a %b %d %H:%M:%S %Y")
}

ExtractDates <- function(descfiles, type) {
  # Extracts dates information from DESCRIPTION files.
  # Args:
  #   descfiles: A dataframe containing DESCRIPTION files (like the
  #              one returned by ReadDescFiles).
  #   type: The type of date to extract (either Date/Publication or
  #   Packaged).
  #
  # Returns:
  #    A four column dataframe with package name, version, date type
  #    and the date.
  d <- GetDescfilesKey(descfiles, type)
  dates <- sapply(strsplit(d$value, ";"), function(x) strftime(ParseDate(x[1])))
  data.frame(package=d$package, version=d$version,
             type=rep(tolower(type), nrow(d)),
             date=as.POSIXlt(dates),
             stringsAsFactors=FALSE)
}
