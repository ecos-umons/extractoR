delim.open <- "(^|[[<({,\"' ])"
email.chars <- "[[:alnum:]._=+-]"
delim.close <- "([]>)},\"' ]|$)"
email.pattern <- sprintf("%s(%s+([ ]?(\\@|\\[at\\])+[ ]?%s+)+)%s",
                         delim.open, email.chars, email.chars, delim.close)

ExtractPersonInfos <- function(s) {
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

ExtractPerson <- function(s) {
  # Extracts all the people defined in a string.
  #
  # Args:
  #   s: The string containing the people name and email.
  #
  # Returns:
  #   A two columns dataframe containing the name and email of people
  #   extracted.
  s <- gsub("(<[a-fA-F0-9]{2}>)", "", s)
  s <- gsub("[[:space:]]+", " ", s)
  s <- unlist(strsplit(s, "( (with|from|by|/|and) )|[,;&>]"))
  s <- Strip(grep("[[:alpha:]]", s, value=TRUE))
  m <- matrix(unlist(lapply(s, ExtractPersonInfos)), nrow=2)
  data.frame(package=rep(package, ncol(m)), version=rep(version, ncol(m)),
             role=rep(role, ncol(m)), name=m[1, ], email=m[2, ],
             stringsAsFactors=FALSE)
}

ExtractRoles <- function(descfiles, role) {
  # Extracts all the people defined in DESCRIPTION files for a given
  # role.
  #
  # Args:
  #   descfiles: A dataframe containing DESCRIPTION files (like the
  #              one returned by ReadDescFiles)
  #   role: The role to extract (either Maintainer or Author).
  #
  # Returns:
  #   A five columns dataframe containing package name, version and
  #   the role, the name and email of people extracted.
  roles <- GetDescfilesKey(descfiles, role)
  Extract <- function(d) {
    df <- ExtractPerson(d["value"])
    df$package <- d["package"]
    df$version <- d["version"]
    df$role <- tolower(d["key"])
    df[, c(2, 3, 4, 1)]
  }
  people <- apply(roles, 1, Extract)
  dflist2df(people)
}

ExtractPeople <- function(roles) {
  # Returns the list of all different people.
  #
  # Args:
  #   roles: A dataframe like the one returned by ExtractRoles.
  #
  # Returns:
  #   A two-column dataframe containing the people names and emails.
  people <- unique(roles[, 4:5])
  rownames(people) <- NULL
  people
}

People2CSV <- function(people, file) {
  # Exports people to a CSV file.
  #
  # Args:
  #   people: The dataframe people (like the one returned by
  #           ExtractPeople)
  #   file: The name of the file to save identities into.
  #
  # Returns:
  #   Nothing
  write.csv2(people, file=file, row.names=FALSE)
}
