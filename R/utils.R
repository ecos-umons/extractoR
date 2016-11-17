HTTPHeader <- function(url) {
  curl <- getCurlHandle()
  getURL(url, header=1, nobody=1, curl=curl)
  res <- getCurlInfo(curl)
  loginfo("HTTP response code %d for %s", res$response.code, url, logger="cran.check")
  res
}

HTTPGetURL <- function(url) {
  res <- HTTPHeader(url)
  code <- res$response.code
  if (code == "301") HTTPGetURL(res$redirect.url)
  else if (code == "200") url
  else NA
}

HTTPGetFile <- function(url) {
  curl <- getCurlHandle()
  getURL(url, curl=curl)
}

HTTPCheck <- function(url) {
  !is.na(HTTPGetURL(url))
}

GuessEncoding <- function(filename) {
  # Guesses the encoding of a file.
  cmd <- sprintf("file --mime-encoding %s", filename)
  strsplit(system(cmd, intern=TRUE), " ")[[1]][2]
}
