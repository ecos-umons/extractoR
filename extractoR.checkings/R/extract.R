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
      (is.na(to.date) | dates < as.POSIXlt(to.date))]
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
  re <- "^(.*>)[^[:alpha:]]*([[:alpha:]].*)$"
  multi <- grep(re, maintainers)
  maintainers[multi] <- sapply(strsplit(gsub(re, "\\1|\\2", maintainers[multi]),
                                        "[|]"), function(x) x[1])
  maintainer.re <- "^(.*)\\s*<(.*@.*)>$"
  errors <- grep(maintainer.re, maintainers, invert=TRUE)
  names <- Strip(sub(maintainer.re, "\\1", maintainers))
  emails <- Strip(sub(maintainer.re, "\\2", maintainers))
  names[is.na(names)] <- ""
  emails[errors] <- ""
  list(names=names, emails=emails)
}

ReadCheckings <- function(date, filename, checkdir, flavors=NULL) {
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
  if (is.null(flavors)) {
    df
  } else {
    df[df$flavor %in% flavors, ]
  }
}

ExtractStatus <- function(date, checkdir) {
  flavors <- c("r-devel-windows-ix86+x86_64",
               "r-patched-solaris-x86",
               "r-release-linux-x86_64",
               "r-release-macosx-x86_64",
               "r-release-windows-ix86+x86_64",
               "r-oldrel-windows-ix86+x86_64",
               "r-devel-macosx-x86_64",
               "r-devel-linux-x86_64-debian",
               "r-devel-linux-x86_64-debian-gcc")
  status <- ReadCheckings(date, "check_results.rds", checkdir, flavors)
  status$flavor <- sub("^(r-[a-z]+-[a-z]+)-.*$", "\\1", status$flavor)
  status
}
