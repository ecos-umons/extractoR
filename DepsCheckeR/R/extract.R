ListCheckings <- function(checkdir, from.date="1970-01-01", to.date=NA) {
  # Lists available checking RDS files.
  #
  # Args:
  #   checkdir: The directory where cheking RDS files are stored.
  #   from.date: Oldest checking to read.
  #   to.date: Newest checkings to read.
  #
  # Returns:
  #   A vector containing the directories name where the different
  #   checking RDS files are stored for each extraction. Those
  #   directories shoudl be named using the date format
  #   "%y-%m-%d-%H-%M".
  res <- grep("\\d\\d(-\\d\\d){4}", dir(checkdir), value=TRUE)
  dates <- ParseDates(res)
  res[dates >= as.POSIXlt(from.date) &
      (is.na(to.date) | dates <= as.POSIXlt(to.date))]
}

ParseDates <- function(dates) {
  # Parses a checking date which uses the format "%y-%m-%d-%H-%M".
  #
  # Args:
  #   dates: A character vector containing dates.
  #
  # Returns:
  #   The parsed dates as POSIXlt.
  as.POSIXlt(dates, format="%y-%m-%d-%H-%M")
}

ExtractMaintainers <- function(maintainers) {
  # Extracts maintainer names from a character vector of well formated
  # maintainers field.
  #
  # Args:
  #   maintainers: A character vector of well formated
  #                maintainers field.
  #
  # Returns:
  #   A list containings the names and emails extracted.
  maintainer.re <- "^(.*)\\s*<(.*@.*)>$"
  errors <- grep(maintainer.re, maintainers, invert=TRUE)
  names <- Strip(sub(maintainer.re, "\\1", maintainers))
  emails <- Strip(sub(maintainer.re, "\\2", maintainers))
  names[is.na(names)] <- ""
  emails[errors] <- ""
  list(names=names, emails=emails)
}

ReadCheckings <- function(date, filename, checkdir) {
  # Reads checking RDS files.
  #
  # Args:
  #   date: The date of the checking to extract. It must be formatted
  #         using the format "%y-%m-%d-%H-%M". It is the directory
  #         where the RDS file is stored.
  #   filename: Name of the RDS file to read.
  #   checkdir: Root dir where all checking files are stored.
  #
  # Returns:
  #    A dataframe containing the row of the read rds file plus a
  #    column with the date of the check.
  filepath <- file.path(checkdir, date, filename)
  date <- ParseDates(date)
  df <- readRDS(filepath)
  df$date <- as.character(date)
  colnames(df) <- tolower(colnames(df))
  if ("priority" %in% colnames(df)) {
    df$priority[is.na(df$priority)] <- "contributed"
  }
  if ("maintainer" %in% colnames(df)) {
    maintainers <- ExtractMaintainers(df$maintainer)
    df$name <- maintainers$names
    df$email <- maintainers$emails
  }
  df
}

ExtractStatus <- function(status, checkings) {
  # Extracts status of packages (ERROR, WARNING, NOTE or OK) based on
  # checking results.
  #
  # Args:
  #   status: CRAN status dataframe like the one returned by
  #           ReadCheckings on check_results.rds.
  #   status: CRAN checkings dataframe like the one returned by
  #           ReadCheckings on check_details.rds.
  #
  # Returns:
  #   status dataframe with an added column "status".
  keys <- paste(checkings$package, checkings$version, checkings$flavor)
  checkings <- split(checkings, keys)
  GetNumStatus <- function(c, type) nrow(c[c$status == type, ])
  errors <- sapply(checkings, GetNumStatus, "ERROR")
  warnings <- sapply(checkings, GetNumStatus, "WARNING")
  notes <- sapply(checkings, GetNumStatus, "NOTE")
  GetStatus <- function(c) {
    if (c["errors"]) "ERROR"
    else if (c["warnings"]) "WARNING"
    else if (c["notes"]) "NOTE"
    else "OK"
  }
  res <- apply(data.frame(errors, warnings, notes), 1, GetStatus)
  status$status <- "OK"
  rownames(status) <- paste(status$package, status$version, status$flavor)
  status[names(res), ]$status <- res
  rownames(status) <- NULL
  status
}

ReadAndInsertStatus <- function(con, checkdir, from.date="1970-01-01",
                                to.date=NA) {
  # Reads CRAN status and checkings and inserts them into a database.
  #
  # Args:
  #   con: The database connection object.
  #   checkdir: Root dir where all checking files are stored.
  #   from.date: Oldest checking to read.
  #   to.date: Newest checkings to read.
  status <- lapply(dates, ReadCheckings, "check_results.rds", checkdir)
  for (date in ListCheckings(checkdir, from.date, to.date)) {
    status <- ReadCheckings(date, "check_results.rds", checkdir)
    checkings <- ReadCheckings(date, "check_details.rds", checkdir)
    message(sprintf("Inserting CRAN status %s", date))
    InsertCRANStatus(con, ExtractStatus(status, checkings))
  }
}
