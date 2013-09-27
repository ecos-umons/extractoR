source("scripts/sql.R")

p1 <- dbGetQuery(con, paste("SELECT p.name, p.email FROM people p, roles r",
                            "WHERE p.id = r.person_id AND r.role = 'maintainer'"))
p2 <- dbGetQuery(con, paste("SELECT p.name, p.email FROM people p, cran_status s",
                            "WHERE p.id = s.maintainer_id"))
identities <- unique(rbind(p1, p2))
