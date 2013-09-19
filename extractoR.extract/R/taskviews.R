GetTaskViewsDataframe <- function() {
  # Returns a data frame listing the current task views.
  #
  # Returns:
  #   A five column dataframe containing the name of the taskview, its
  #   topic, its maintainer name and email, and its version.
  ctv <- CRAN.views()
  taskviews <- sapply(ctv, function(x) x$name)
  topics <- sapply(ctv, function(x) x$topic)
  names <- sapply(ctv, function(x) x$maintainer)
  emails <- sapply(ctv, function(x) x$email)
  versions <- sapply(ctv, function(x) x$version)
  data.frame(taskview=taskviews, topic=topics, name=names, email=emails,
             version=as.POSIXlt(versions), stringsAsFactors=FALSE)
}

GetTaskViewContent <- function(taskview) {
  # Returns a data frame listing the current content of a task view.
  #
  # Arg:
  #   taskview: The taskview object.
  #
  # Returns:
  #   A four column dataframe containing the name and version of the
  #   taskview, the name of the package a boolean indicating if it is
  #   a core taskview or not.
  n <- nrow(taskview$package)
  data.frame(taskview=rep(taskview$name, n),
             version=rep(taskview$version, n),
             package=taskview$package$name, core=taskview$package$core,
             stringsAsFactors=FALSE)
}

GetTaskViewsContent <- function() {
  # Returns a data frame listing the current content of all task views.
  #
  # Returns:
  #   A four column dataframe containing the name and version of the
  #   taskview, the name of the package a boolean indicating if it is
  #   a core taskview or not.
  ctv <- CRAN.views()
  df <- dflist2df(lapply(ctv, GetTaskViewContent))
  df$version <- as.POSIXlt(df$version)
  df
}
