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
  df <- data.frame(package=d$package, version=d$version,
                   type=rep(tolower(type), nrow(d)),
                   date=as.POSIXlt(dates),
                   stringsAsFactors=FALSE)
  df[!is.na(df$date), ]
}
