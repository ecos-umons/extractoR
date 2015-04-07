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

GuessEncoding <- function(filename) {
  # Guesses the encoding of a file.
  cmd <- sprintf("file --mime-encoding %s", filename)
  strsplit(system(cmd, intern=TRUE), " ")[[1]][2]
}
