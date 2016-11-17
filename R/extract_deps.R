Dependencies <- function(descfiles, types) {
  pkgname.re <- "([[:alpha:]][[:alnum:].]*)"
  version.re <- "[-[:digit:].]+"
  constraint.re <- sprintf("[(][>=<]=?[[:space:]]*(%s)[)]", version.re)
  dependency.re <- sprintf("%s([[:space:]]*%s)?", pkgname.re, constraint.re)
  dependencies.re <- "^[[:space:]]*((%s)([[:space:]]*,[[:space:]]*%s)*,?)?$"
  dependencies.re <- sprintf(dependencies.re, dependency.re, dependency.re)

  ParseDependency <- function(string) {
    # Parses a dependencies string.
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
      loginfo("Parsing %s of %s:%s:%s", key, source, repository, ref)
      deps <- ParseDependency(value)
      if (nrow(deps)) {
        cbind(data.table(source, repository, ref, type.name, key), deps)
      }
    }, deps$source, deps$repo, deps$ref, deps$key, deps$value, SIMPLIFY=FALSE))
  }

  if (is.null(names(types))) {
    names(types) <- sapply(types, function(t) tolower(t[1]))
  }
  rbindlist(mapply(function(name, keys) {
    ParseDependencies(descfiles, keys, name)
  }, names(types), types, SIMPLIFY=FALSE))
}

ExtractDependencies <- function(db="rdata", host="mongodb://localhost") {
  index <- mongo("index", db, host)$find()

  con <- mongo("dependencies", db, host)
  message("Extracting dependencies")
  t <- system.time({
    descfiles <- as.data.table(mongo("description", db, host)$find())
    missing <- MissingEntries(index, con)[, list(source, repository, ref)]
    missing <- setkey(descfiles, source, repository, ref)[missing]
    fields <- list("Depends", "Imports", "Suggests", "Enhances", "LinkingTo")
    ## fields <- list(c("Depends", "Depents", "%Depends", "Dependes", "Depens",
    ##                  "Dependencies", "DependsSplus", "DependsTERR"),
    ##                c("Imports", "#Imports", "Import"),
    ##                c("Suggests", "SUGGESTS", "suggests", "Suggets", "Suggest",
    ##                  "%Suggests", "Recommends"),
    ##                c("Enhances", "Enhanves"),
    ##                c("LinkingTo", "LinkingdTo"))
    deps <- Dependencies(missing, fields)
  })
  message(sprintf("Dependencies extracted in %.3fs", t[3]))
  con$insert(deps)
}
