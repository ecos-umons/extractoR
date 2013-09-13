ListCheckings <- function(checkdir, from.date="1970-01-01") {
  # Lists available checking RDS files.
  #
  # Args:
  #   checkdir: The directory where cheking RDS files are stored.
  #   from.date: Oldest checking to read.
  #
  # Returns:
  #   A vector containing the directories name where the different
  #   checking RDS files are stored for each extraction. Those
  #   directories shoudl be named using the date format
  #   "%y-%m-%d-%H-%M".
  from.date <- as.POSIXlt(from.date)
  res <- grep("\\d\\d(-\\d\\d){4}", dir(checkdir), value=TRUE)
  res[ParseDates(res) >= from.date]
}

ParseDates <- function(dates) {
  # Parses a checking date which uses the format "%y-%m-%d-%H-%M".
  #
  # Args:
  #   dates: A character vector containing dates.
  #
  # Returns:
  #   The parsed dates as POSIXlt.
  as.POSIXlt(dates, tz="EST", format="%y-%m-%d-%H-%M")
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

ReadAndInsert <- function(con, checkdir, from.date="1970-01-01") {
  # Reads CRAN status and checkings and inserts them into a database
  #
  # Args:
  #   con: The database connection object.
  #   checkdir: Root dir where all checking files are stored.
  #   from.date: Oldest checking to read.
  dates <- ListCheckings(checkdir, from.date)
  status <- lapply(dates, ReadCheckings, "check_results.rds", checkdir)
  for (i in 1:length(dates)) {
    message(sprintf("Inserting status %s", dates[i]))
    InsertCRANStatus(con, status[[i]])
  }
  checkings <- lapply(dates, ReadCheckings, "check_details.rds", checkdir)
  for (i in 1:length(dates)) {
    message(sprintf("Inserting checkings %s", dates[i]))
    InsertCRANChecking(con, checkings[[i]])
  }
}
