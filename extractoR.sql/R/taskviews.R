InsertTaskviews <- function(con, taskviews) {
  taskviews <- unique(taskviews)
  message(sprintf("Inserting %d taskviews", nrow(taskviews)))
  names <- FormatString(con, taskviews$taskview)
  topics <- FormatString(con, taskviews$topic)
  taskviews <- data.frame(name=names, topic=topics)
  InsertDataFrame(con, "taskviews", taskviews)
}

GetTaskViews <- function(con) {
  dbGetQuery(con, "SELECT id, name FROM taskviews")
}

GetHashTaskViews <- function(con) {
  taskviews <- GetTaskViews(con)
  hash(taskviews$name, taskviews$id)
}

InsertTaskViewVersions <- function(con, versions) {
  versions <- unique(versions)
  message(sprintf("Inserting %d taskview versions", nrow(versions)))
  taskviews <- GetHashTaskViews(con)
  taskviews <- sapply(versions$taskview, function(t) taskviews[[t]])
  people <- GetHashPeople(con)
  people <- apply(versions, 1, function(p) people[[GetPersonKey(p)]])
  versions <- FormatString(con, as.character(versions$version))
  versions <- data.frame(version=versions, taskview_id=taskviews,
                         maintainer_id=people)
  InsertDataFrame(con, "taskview_versions", versions)
}

GetTaskViewVersions <- function(con) {
  dbGetQuery(con, paste("SELECT v.id, t.name taskview, v.version",
                        "FROM taskviews t, taskview_versions v",
                        "WHERE t.id = v.taskview_id"))
}

GetTaskViewVersionKey <- function(taskview) {
  sprintf("%s %s", taskview["taskview"], taskview["version"])
}

GetHashTaskViewVersion <- function(con) {
  taskviews <- GetTaskViewVersions(con)
  hash(apply(taskviews, 1, GetTaskViewVersionKey), taskviews$id)
}

InsertTaskViewContent <- function(con, content) {
  content <- unique(content)
  content$version <- as.character(content$version)
  message(sprintf("Inserting %d taskview content", nrow(content)))
  taskviews <- GetHashTaskViewVersion(con)
  taskviews <- apply(content[, c("taskview", "version")], 1,
                     function(t) taskviews[[GetTaskViewVersionKey(t)]])
  packages <- GetHashPackages(con)
  packages <- sapply(content$package, function(p) packages[[p]])
  cores <- as.character(content$core)
  content <- data.frame(taskview_id=taskviews, package_id=packages, core=cores)
  InsertDataFrame(con, "taskview_content", content)
}
