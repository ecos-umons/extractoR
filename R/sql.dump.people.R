library(RMySQL)

delim.open <- "(^|[[<({,\"' ])"
email.chars <- "[[:alnum:]._=+-]"
delim.close <- "([]>)},\"' ]|$)"
email.pattern <- sprintf("%s(%s+([ ]?(\\@|\\[at\\])+[ ]?%s+)+)%s",
                         delim.open, email.chars, email.chars, delim.close)

person.extract.email <- function(s) {
  if(length(s) & grepl(email.pattern, s)) {
    list(name=strip(gsub(email.pattern, "", s)),
         email=gsub(paste("^.*", email.pattern, ".*$", sep=""), "\\2", s))
  } else {
    list(name=s, email="")
  }
}

person.extract <- function(s) {
  s <- gsub("(<[a-fA-F0-9]{2}>)", "", s)
  s <- gsub("[[:space:]]+", " ", s)
  s <- unlist(strsplit(s, "( (with|from|by|/|and) )|[,;&>]"))
  s <- strip(s[grep("[[:alpha:]]", s)])
  lapply(s, extract.email)
}

person.insert <- function(con, name, email) {
  name <- dbEscapeStrings(con, name)
  email <- dbEscapeStrings(con, email)
  query <- sprintf("INSERT INTO people (name, email) VALUES ('%s', '%s')",
                   name, email)
  dbClearResult(dbSendQuery(con, query))
  dbGetQuery(con, "SELECT LAST_INSERT_ID()")[1, 1]
}

person.ensure <- function(con, name, email) {
  id <- get.person.id(con, name, email)
  if(is.null(id)) {
    id <- insert.person(con, name, email)
  }
  id
}

people.ensure <- function(con, people) {
  people <- unique(unlist(people$people, recursive=FALSE))
  for(person in people) {
    ensure.person(con, person$name, person$email)
  }
}

## con <- dbConnect(MySQL(), user="gnome", password="gnomepass", dbname="rdata")
## dbClearResult(dbSendQuery(con, "SET NAMES utf8"))
## df <- sql.load(con)
## roles <- rbind(get.maintainers(con), get.authors(con))
## roles$people <- lapply(people$people, extract.person)

## ensure.roles.all(con, roles[1:10, ])

# TODO

## Use name tagger => for detecting names
