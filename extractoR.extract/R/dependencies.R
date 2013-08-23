pkgname.re <- "([[:alpha:]][[:alnum:].]*)"
version.re <- "[-[:digit:].]+"
constraint.re <- sprintf("[(](>=?|==|<=?)?[[:space:]]*(%s)[)]", version.re)
dependency.re <- sprintf("%s([[:space:]]*%s)?", pkgname.re, constraint.re)
dependencies.re <- "^[[:space:]]*((%s)([[:space:]]*,[[:space:]]*%s)*,?)?$"
dependencies.re <- sprintf(dependencies.re, dependency.re, dependency.re)

ExtractDependency <- function(package, version, type, dependencies) {
  d <- as.vector(sapply(strsplit(dependencies, ","), Strip))
  n <- length(d)
  data.frame(package=rep(package, length(d)), version=rep(version, length(d)),
             type=rep(type, length(d)),
             depends.on=sub(sprintf("^%s$", dependency.re), "\\1", d),
             constraint.type=sub(sprintf("^%s$", dependency.re), "\\3", d),
             constraint.version=sub(sprintf("^%s$", dependency.re), "\\4", d))
}

ExtractDependencies <- function(descfiles, type) {
  dep <- GetDescfilesKey(descfiles, type)
  dep <- dep[grep(dependencies.re, dep$value),]
  dependencies <- apply(dep, 1,
                        function(d) ExtractDependency(d["package"],
                                                      d["version"],
                                                      tolower(d["key"]),
                                                      d["value"]))
  dflist2df(dependencies, c("package", "version", "type", "depends.on",
                            "constraint.type", "constraint.version"))
}
