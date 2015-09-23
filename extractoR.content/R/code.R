FunctionDefinitions <- function(package) {
  loginfo("Parsing R functions from package %s %s %s",
          package$source, package$repository, package$ref, logger="functions")
  if (!is.null(package$code)) {
    package <- c(package, sourceR::FunctionDefinitions(package$code))
  }
  package$code <- NULL
  package
}

FunctionCalls <- function(package) {
  loginfo("Parsing R function calls from package %s %s %s",
          package$source, package$repository, package$ref, logger="functions")
  if (!is.null(package$code)) {
    calls <- sourceR::FunctionCalls(package$code)
    if (!is.null(calls)) {
      package <- c(package, calls)
      package$code <- NULL
      package
    }
  }
}

CodingStyle <- function(package) {
  loginfo("Parsing R functions from package %s %s %s",
          package$source, package$repository, package$ref, logger="functions")
  if (!is.null(package$code)) {
    package <- c(package, sourceR::CodingStyle(package$code))
  }
  package$code <- NULL
  package
}
