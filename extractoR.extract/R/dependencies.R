pkgname.re <- "([[:alpha:]][[:alnum:].]*)"
version.re <- "[-[:digit:].]+"
constraint.re <- sprintf("[(](>=?|==|<=?)?[[:space:]]*(%s)[)]", version.re)
dependency.re <- sprintf("%s([[:space:]]*%s)?", pkgname.re, constraint.re)
dependencies.re <- "^[[:space:]]*((%s)([[:space:]]*,[[:space:]]*%s)*,?)?$"
dependencies.re <- sprintf(dependencies.re, dependency.re, dependency.re)

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
  #   type of the dependency, the package in depends on (depends.on),
  #   the constraint type (constraint.type) which is either >, >=, <,
  #   <=, == or nothing, and the constraint version
  #   (constraint.version) if any.
  d <- as.vector(sapply(strsplit(dependencies, ","), Strip))
  n <- length(d)
  data.frame(package=rep(package, length(d)), version=rep(version, length(d)),
             type=rep(type, length(d)),
             depends.on=sub(sprintf("^%s$", dependency.re), "\\1", d),
             constraint.type=sub(sprintf("^%s$", dependency.re), "\\3", d),
             constraint.version=sub(sprintf("^%s$", dependency.re), "\\4", d))
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
  #   type of the dependency, the package in depends on (depends.on),
  #   the constraint type (constraint.type) which is either >, >=, <,
  #   <=, == or nothing, and the constraint version
  #   (constraint.version) if any.
  dep <- GetDescfilesKey(descfiles, type)
  dep <- dep[grep(dependencies.re, dep$value),]
  dependencies <- apply(dep, 1,
                        function(d) ExtractDependency(d["package"],
                                                      d["version"],
                                                      tolower(d["key"]),
                                                      d["value"]))
  dflist2df(dependencies)
}
