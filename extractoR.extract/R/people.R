delim.open <- "(^|[[<({,\"' ])"
email.chars <- "[[:alnum:]._=+-]"
delim.close <- "([]>)},\"' ]|$)"
email.pattern <- sprintf("%s(%s+([ ]?(\\@|\\[at\\])+[ ]?%s+)+)%s",
                         delim.open, email.chars, email.chars, delim.close)

ExtractPerson <- function(s) {
  # Extracts a name and an email from a string containing them.
  #
  # Args:
  #   s: The string containing the person's name and email.
  #
  # Returns:
  #   A list with the name and email.
  if (grepl(email.pattern, s)) {
    list(name=Strip(gsub(email.pattern, "", s)),
         email=gsub(paste("^.*", email.pattern, ".*$", sep=""), "\\2", s))
  } else {
    list(name=s, email="")
  }
}

ExtractPeople <- function(s) {
  # Extracts all the people defined in a string.
  #
  # Args:
  #   s: The string containing the people name and email.
  #
  # Returns:
  #   A two columns datatable containing the name and email of people
  #   extracted.
  s <- gsub("(<[a-fA-F0-9]{2}>)", "", s)
  s <- gsub("[[:space:]]+", " ", s)
  s <- unlist(strsplit(s, "( (with|from|by|/|and) )|[,;&>]"))
  s <- Strip(grep("[[:alpha:]]", s, value=TRUE))
  m <- matrix(unlist(lapply(s, ExtractPerson)), nrow=2)
  data.table(name=m[1, ], email=m[2, ])
}

ExtractRoles <- function(descfiles, role) {
  # Extracts all the people defined in DESCRIPTION files for a given
  # role.
  roles <- descfiles[tolower(key) == tolower(role), ]
  rbindlist(mapply(function(package, version, value) {
    people <- ExtractPeople(value)
    if (nrow(people)) {
      cbind(data.table(package, version, role=tolower(role)), people)
    }
  }, roles$package, roles$version, roles$value, SIMPLIFY=FALSE))
}
