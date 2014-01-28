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

  data.frame(name=names, compare=compare,
             version=versions, stringsAsFactors=FALSE)
}

ExtractDependency <- function(package, version, type, dependencies) {
  # Extracts the dependencies defined in a dependencies string.
  #
  # Args:
  #   package: The package name.
  #   version: The package version
  #   type: The type of dependency to extract (either Depends,
  #         Imports, Suggests or Enhances).
  #   dependencies: The dependencies string.
  #
  # Returns:
  #   A six columns dataframe containing package name, version, the
  #   type of the dependency, the package in depends on (dependency),
  #   the constraint type (constraint.type) which is either >, >=, <,
  #   <=, == or nothing, and the constraint version
  #   (constraint.version) if any.
  deps <- ParseDependencies(dependencies)
  deps[4:6] <- deps[1:3]
  names(deps) <- c("package", "version", "type", "dependency",
                   "constraint.type", "constraint.version")
  if (nrow(deps)) {
    deps$package <- package
    deps$version <- version
    deps$type <- type
  }
  deps
}

ExtractDependencies <- function(descfiles, type) {
  # Extracts all the dependencies defined in DESCRIPTION files for a
  # given dependency type.
  #
  # Args:
  #   descfiles: A dataframe containing DESCRIPTION files (like the
  #              one returned by ReadDescFiles)
  #   type: The type of dependency to extract (either Depends,
  #         Imports, Suggests or Enhances).
  #
  # Returns:
  #   A six columns dataframe containing package name, version, the
  #   type of the dependency, the package in depends on (dependency),
  #   the constraint type (constraint.type) which is either >, >=, <,
  #   <=, == or nothing, and the constraint version
  #   (constraint.version) if any.
  deps <- descfiles[descfiles$key==type, ]
  deps <- deps[grep(dependencies.re, deps$value),]
  FlattenDF(apply(deps, 1, function(d) {
    ExtractDependency(d["package"], d["version"],
                      tolower(d["key"]), d["value"])
  }))
}
