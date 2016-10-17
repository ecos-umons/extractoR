pkgname.re <- "([[:alpha:]][[:alnum:].]*)"
version.re <- "[-[:digit:].]+"
constraint.re <- sprintf("[(][>=<]=?[[:space:]]*(%s)[)]", version.re)
dependency.re <- sprintf("%s([[:space:]]*%s)?", pkgname.re, constraint.re)
dependencies.re <- "^[[:space:]]*((%s)([[:space:]]*,[[:space:]]*%s)*,?)?$"
dependencies.re <- sprintf(dependencies.re, dependency.re, dependency.re)

ParseDependency <- function(string) {
  # Parses a dependencies string.
  #
  # Args:
  #   string: The string containing the dependencies to parse
  #
  # Returns:
  #    A three column dataframe containing a dependency on each row
  #    with package name, compare symbol and version.
  pieces <- strsplit(string, ",")[[1]]
  names <- str_trim(gsub("\\s*\\(.*?\\)", "", pieces))

  versions.str <- pieces
  versions.str[!grepl("\\(.*\\)", versions.str)] <- NA
  compare  <- str_trim(sub(".*\\(\\s*([=><]+).*\\)", "\\1", versions.str))
  versions <- str_trim(sub(".*\\(\\s*[=><]+(.*)\\)", "\\1", versions.str))

  compare.nna   <- compare[!is.na(compare)]
  compare.valid <- compare.nna %in% c(">", ">=", "=", "==", "<=", "<")
  if(!all(compare.valid)) {
    stop("Invalid comparison operator in dependency: ",
      paste(compare.nna[!compare.valid], collapse = ", "))
  }
  compare[compare == "=="] <- "="

  data.table(dependency=names, constraint.type=compare,
             constraint.version=versions)
}

ParseDependencies <- function(descfiles, keys, type.name=tolower(keys[1])) {
  # Parses all the dependencies defined in DESCRIPTION files for a
  # given dependency type.
  deps <- descfiles[tolower(key) %in% tolower(keys), ]
  deps <- deps[grep(dependencies.re, deps$value),]
  rbindlist(mapply(function(source, repository, ref, key, value) {
    deps <- ParseDependency(value)
    if (nrow(deps)) {
      cbind(data.table(source, repository, ref, type.name, key), deps)
    }
  }, deps$source, deps$repo, deps$ref, deps$key, deps$value, SIMPLIFY=FALSE))
}

Dependencies <- function(descfiles, types) {
  if (is.null(names(types))) {
    names(types) <- sapply(types, function(t) tolower(t[1]))
  }
  rbindlist(mapply(function(name, keys) {
    ParseDependencies(descfiles, keys, name)
  }, names(types), types, SIMPLIFY=FALSE))
}
