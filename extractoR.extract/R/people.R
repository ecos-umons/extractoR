delim.open <- "(^|[[<({,\"' ])"
email.chars <- "[[:alnum:]._=+-]"
delim.close <- "([]>)},\"' ]|$)"
email.pattern <- sprintf("%s(%s+([ ]?(\\@|\\[at\\])+[ ]?%s+)+)%s",
                         delim.open, email.chars, email.chars, delim.close)

ExtractPersonInfos <- function(s) {
  if (grepl(email.pattern, s)) {
    list(name=Strip(gsub(email.pattern, "", s)),
         email=gsub(paste("^.*", email.pattern, ".*$", sep=""), "\\2", s))
  } else {
    list(name=s, email="")
  }
}

ExtractPerson <- function(package, version, role, s) {
  s <- gsub("(<[a-fA-F0-9]{2}>)", "", s)
  s <- gsub("[[:space:]]+", " ", s)
  s <- unlist(strsplit(s, "( (with|from|by|/|and) )|[,;&>]"))
  s <- Strip(grep("[[:alpha:]]", s, value=TRUE))
  m <- matrix(unlist(lapply(s, ExtractPersonInfos)), nrow=2)
  data.frame(package=rep(package, ncol(m)), version=rep(version, ncol(m)),
             role=rep(role, ncol(m)), name=m[1, ], email=m[2, ])
}

ExtractRoles <- function(descfiles, role) {
  roles <- GetDescfilesKey(descfiles, role)
  people <- apply(roles, 1,
                  function(d) ExtractPerson(d["package"], d["version"],
                                            tolower(d["key"]), d["value"]))
  dflist2df(people, c("package", "version", "role", "name", "email"))
}

ExtractPeople <- function(maintainers, authors) {
  unique(rbind(unique(maintainers[, 4:5]), unique(authors[, 4:5])))
}
