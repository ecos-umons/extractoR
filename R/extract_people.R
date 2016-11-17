Roles <- function(descfiles, role) {
  # Extracts all the people defined in DESCRIPTION files for a given
  # role.
  delim.open <- "(^|[[<({,\"' ])"
  email.chars <- "[[:alnum:]._=+-]"
  delim.close <- "([]>)},\"' ]|$)"
  email.pattern <- sprintf("%s(%s+([ ]?(\\@|\\[at\\])+[ ]?%s+)+)%s",
                           delim.open, email.chars, email.chars, delim.close)

  ExtractPerson <- function(s) {
    # Extracts a name and an email from a string containing them.
    if (grepl(email.pattern, s)) {
      list(name=str_trim(gsub(email.pattern, "", s)),
           email=gsub(paste("^.*", email.pattern, ".*$", sep=""), "\\2", s))
    } else {
      list(name=s, email="")
    }
  }

  ExtractPeople <- function(s) {
    # Extracts all the people defined in a string.
    s <- gsub("(<[a-fA-F0-9]{2}>)", "", s)
    s <- gsub("[[:space:]]+", " ", s)
    s <- unlist(strsplit(s, "( (with|from|by|/|and) )|[,;&>]"))
    s <- str_trim(grep("[[:alpha:]]", s, value=TRUE))
    m <- matrix(unlist(lapply(s, ExtractPerson)), nrow=2)
    data.table(name=m[1, ], email=m[2, ])
  }

  roles <- descfiles[tolower(key) == tolower(role) & grepl("\\S", value), ]
  rbindlist(mapply(function(source, repository, ref, value) {
    loginfo("Parsing %s of %s:%s:%s", role, source, repository, ref)
    people <- ExtractPeople(value)
    if (nrow(people)) {
      cbind(data.table(source, repository, ref, role=tolower(role)), people)
    }
  }, roles$source, roles$repository, roles$ref, roles$value, SIMPLIFY=FALSE))
}

ExtractRoles <- function(db="rdata", host="mongodb://localhost") {
  index <- mongo("index", db, host)$find()

  con <- mongo("roles", db, host)
  message("Extracting roles")
  t <- system.time({
    descfiles <- as.data.table(mongo("description", db, host)$find())
    missing <- MissingEntries(index, con)[, list(source, repository, ref)]
    missing <- setkey(descfiles, source, repository, ref)[missing]
    roles <- Roles(missing, "maintainer")
  })
  message(sprintf("Roles extracted in %.3fs", t[3]))
  con$insert(roles)
}
