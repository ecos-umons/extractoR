ReadCheck <- function(date, filename, checkdir) {
  # Reads check RDS files.
  #
  # Args:
  #   date: The date of the check to extract. It must be formatted
  #         using the format "%y-%m-%d-%H-%M". It is the directory
  #         where the RDS file is stored.
  #   filename: Name of the RDS file to read.
  #   checkdir: Root dir where all check files are stored.
  #
  # Returns:
  #    A dataframe containing the row of the read rds file plus a
  #    column with the date of the check.
  filepath <- file.path(checkdir, date, filename)
  date <- as.POSIXlt(date, tz="EST", format="%y-%m-%d-%H-%M")
  df <- readRDS(filepath)
  df$date <- as.character(date)
  df
}

ReadChecks <- function(checkdir) {
  # Reads check RDS files.
  #
  # Args:
  #   checkdir: Root dir where all check files are stored.
  #
  # Returns:
  #    A dataframe containing the row of the read rds file plus a
  #    column with the date of the check.
  checks <- grep("\\d\\d(-\\d\\d){4}", dir(checkdir), value=TRUE)
  df <- dflist2df(lapply(checks, ReadCheck, "check_details.rds", checkdir))
  df$date <- as.POSIXlt(df$date)
  df
}
