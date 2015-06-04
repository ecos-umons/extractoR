HTTPHeader <- function(url) {
  curl <- getCurlHandle()
  getURL(url, header=1, nobody=1, curl=curl)
  res <- getCurlInfo(curl)
  loginfo("HTTP response code %d for %s", res$response.code, url, logger="github.check")
  res
}

HTTPCheck <- function(url) {
  res <- HTTPHeader(url)
  code <- res$response.code
  if (code == "301") HTTPCheck(res$redirect.url)
  else code == "200"
}
