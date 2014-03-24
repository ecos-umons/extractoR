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

FlattenDF <- function(l, keep.rownames=FALSE) {
  # Converts a list of dataframes which have the same columns to a
  # single dataframe.
  #
  # Args:
  #   l: The list of dataframes.
  #   keep.rownames: Keep rownames if TRUE.
  #
  # Returns:
  #   The new dataframe which is the concatenation of all rows of the
  #   dataframes contained in the list.
  names(l) <- NULL
  classes <- sapply(l[[1]], class)
  if (keep.rownames) {
    rownames <- as.vector(unlist(sapply(l, rownames)))
  }
  c.row <- function(n) {
    is.factor <- classes[n] == "factor"
    res <- do.call(base::c, lapply(l, function(x) {
      if (is.factor) as.character(x[[n]]) else x[[n]]
    }))
    if (is.factor) factor(res) else res
  }
  df <- lapply(names(classes), c.row)
  df <- as.data.frame(df, stringsAsFactors=FALSE)
  colnames(df) <- names(classes)
  if (keep.rownames) {
    if (length(unique(rownames)) == nrow(df)) {
      rownames(df) <- rownames
    }
  }
  df
}

GuessEncoding <- function(filename) {
  # Guesses the encoding of a file.
  cmd <- sprintf("file --mime-encoding %s", filename)
  strsplit(system(cmd, intern=TRUE), " ")[[1]][2]
}
