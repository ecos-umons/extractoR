pkgname.re <- "([[:alpha:]][[:alnum:].]*)"
version.re <- "[-[:digit:].]+"
constraint.re <- sprintf("[(](>=?|==|<=?)?[[:space:]]*(%s)[)]", version.re)
dependency.re <- sprintf("%s([[:space:]]*%s)?", pkgname.re, constraint.re)
dependencies.re <- "^[[:space:]]*((%s)([[:space:]]*,[[:space:]]*%s)*,?)?$"
dependencies.re <- sprintf(dependencies.re, dependency.re, dependency.re)

ParseDependencies <- function(string) {
  # Parses a dependencies string.
  #
  # Args:
  #   string: The string containing the dependencies to parse
  #
  # Returns:
  #    A three column dataframe containing a dependency on each row
  #    with package name, compare symbol and version.
  pieces <- strsplit(string, ",")[[1]]
  names <- Strip(gsub("\\s*\\(.*?\\)", "", pieces))

  versions.str <- pieces
  versions.str[!grepl("\\(.*\\)", versions.str)] <- NA
  compare  <- Strip(sub(".*\\(\\s*([=><]*).*\\)", "\\1", versions.str))
  versions <- Strip(sub(".*\\(\\s*[=><]*(.*)\\)", "\\1", versions.str))

  compare.nna   <- compare[!is.na(compare)]
  compare.valid <- compare.nna %in% c(">", ">=", "==", "<=", "<", "")
  if(!all(compare.valid)) {
    stop("Invalid comparison operator in dependency: ",
      paste(compare.nna[!compare.valid], collapse = ", "))
  }

  data.table(dependency=names, constraint.type=compare,
             constraint.version=versions)
}

ExtractDependency <- function(package, version, type.name, key, dependencies) {
  # Extracts the dependencies defined in a dependencies string.
  deps <- ParseDependencies(dependencies)
  if (nrow(deps)) {
    cbind(data.table(package, version, type.name, key), deps)
  }
}

ExtractDependencies <- function(descfiles, types, type.name=tolower(types[1])) {
  # Extracts all the dependencies defined in DESCRIPTION files for a
  # given dependency type.
  deps <- descfiles[tolower(descfiles$key) %in% tolower(types), ]
  deps <- deps[grep(dependencies.re, deps$value),]
  rbindlist(mapply(function(package, version, key, value) {
    ExtractDependency(package, version, type.name, key, value)
  }, deps$package, deps$version, deps$key, deps$value, SIMPLIFY=FALSE))
}
