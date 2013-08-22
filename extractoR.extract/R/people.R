delim.open <- "(^|[[<({,\"' ])"
email.chars <- "[[:alnum:]._=+-]"
delim.close <- "([]>)},\"' ]|$)"
email.pattern <- sprintf("%s(%s+([ ]?(\\@|\\[at\\])+[ ]?%s+)+)%s",
                         delim.open, email.chars, email.chars, delim.close)

person.extract.infos <- function(s) {
  if(grepl(email.pattern, s)) {
    list(name=strip(gsub(email.pattern, "", s)),
         email=gsub(paste("^.*", email.pattern, ".*$", sep=""), "\\2", s))
  } else {
    list(name=s, email="")
  }
}

person.extract <- function(package, version, role, s) {
  s <- gsub("(<[a-fA-F0-9]{2}>)", "", s)
  s <- gsub("[[:space:]]+", " ", s)
  s <- unlist(strsplit(s, "( (with|from|by|/|and) )|[,;&>]"))
  s <- strip(grep("[[:alpha:]]", s, value=TRUE))
  m <- matrix(unlist(lapply(s, person.extract.infos)), nrow=2)
  data.frame(package=rep(package, ncol(m)), version=rep(version, ncol(m)),
             role=rep(role, ncol(m)), name=m[1,], email=m[2,])
}

roles.extract <- function(descfiles, role) {
  roles <- descfiles.key(descfiles, role)
  people <- apply(roles, 1,
                  function(d) person.extract(d["package"], d["version"],
                                             tolower(d["key"]), d["value"]))
  dflist2df(people, c("package", "version", "role", "name", "email"))
}

people.df <- function(maintainers, authors) {
  unique(rbind(unique(maintainers[,4:5]), unique(authors[,4:5])))
}
