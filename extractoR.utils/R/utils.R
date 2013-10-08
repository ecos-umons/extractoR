RStrip <- function(s) {
  # Remove all trailing spaces from a string.
  #
  # Args:
  #   s: The string.
  #
  # Returns:
  #   The string without trailing spaces.
  sub("[[:space:]]*$", "", s)
}

LStrip <- function(s) {
  # Remove all leading spaces from a string.
  #
  # Args:
  #   s: The string.
  #
  # Returns:
  #   The string without leading spaces.
  sub("^[[:space:]]*", "", s)
}

Strip <- function(s) {
  # Remove all leading and trailing spaces from a string.
  #
  # Args:
  #   s: The string.
  #
  # Returns:
  #   The string without leading andtrailing spaces.
  gsub("^[[:space:]]*|[[:space:]]*$", "", s)
}

ParseArchiveName <- function(archive) {
  # Parses a package archive name in order to get the package name and
  # version of the archive.
  #
  # Args:
  #   s: The package archive name.
  #
  # Returns:
  #   A list containig the name of the package (package) and version
  #   (version).
  archive <- strsplit(archive, "_")[[1]]
  list(package=archive[1], version=strsplit(archive[2], "\\.tar\\.gz")[[1]][1])
}

dflist2df <- function(l) {
  # Converts a list of dataframes which have the same columns to a
  # single dataframe.
  #
  # Args:
  #   l: The list of dataframes.
  #
  # Returns:
  #   The new dataframe which is the concatenation of all rows of the
  #   dataframes contained in the list.
  names <- names(l[[1]])
  names(l) <- NULL
  l <- unlist(l, recursive=FALSE)
  GetColumn <- function (x) unlist(l[names(l) == x], recursive=FALSE)
  df <- as.data.frame(lapply(as.list(names), GetColumn),
                      stringsAsFactors = FALSE)
  colnames(df) <- names
  df
}
