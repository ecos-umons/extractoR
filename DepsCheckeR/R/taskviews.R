FilterGraph <- function(g, nodes, mode="out") {
  # Returns a subset of a dependency graph containing given nodes and
  # all their dependencies.
  #
  # Args:
  #   g: The graph object.
  #   nodes: List of nodes to select.
  #   mode: Dependencies (out), reverse dependencies (in) or both
  #         (all).
  #
  # Returns:
  #   The sub graph with added nodes and attribute "missing" if some
  #   nodes weren't in the graph.
  GetAllDependencies <- function(node) {
    paths <- shortest.paths(g, node, mode)[1, ]
    names(paths[paths < Inf])
  }
  nodes.missing <- setdiff(nodes, V(g)$name)
  nodes <- setdiff(nodes, nodes.missing)
  nodes <- unlist(lapply(nodes, GetAllDependencies))
  g <- induced.subgraph(g, nodes)
  if (length(nodes.missing)) {
    if (is.null(V(g)$missing)) {
      V(g)$missing <- 0
    }
    g + vertices(nodes.missing, missing=1)
  } else {
    g
  }
}

GetTaskViewPackagesGraph <- function(con, g, date, taskview=NULL) {
  # Returns a dependency graph for a taskviews
  #
  # Args:
  #   con: The connection object to the database.
  #   g: The dependency graph object.
  #   date: The date to use as taskviews version number.
  #   taskview: The taskview to use (if NULL uses all taskviews).
  #
  # Returns:
  #   The sub graph using taskviews
  query <- paste("SELECT p.name package",
                 "FROM taskviews t, taskview_versions v,",
                 "taskview_content c, packages p",
                 "WHERE t.id = v.taskview_id AND v.id = c.taskview_id",
                 "AND c.package_id = p.id",
                 "AND v.version = (SELECT max(v2.version)",
                 "FROM taskview_versions v2",
                 sprintf("WHERE v2.version < '%s'", date),
                 "AND v2.taskview_id = t.id)")
  if (!is.null(taskview)) {
    query <- paste(query, sprintf("AND t.name = %s",
                                  FormatString(con, taskview)))
  }
  packages <- dbGetQuery(con, query)$package
  FilterGraph(g, packages)
}

GetTaskViewMaintainersGraph <- function(con, g, date, flavor, taskview=NULL) {
  # Returns a maintainers dependency graph for a taskviews
  #
  # Args:
  #   con: The connection object to the database.
  #   g: The dependency graph object.
  #   date: The date to use as taskviews version number.
  #   flavor: The flavor to use.
  #   taskview: The taskview to use (if NULL uses all taskviews).
  #
  # Returns:
  #   The sub graph using taskviews
  query <- paste("SELECT mp.name maintainer",
                 "FROM taskviews t, taskview_versions tv,",
                 "taskview_content c, packages p, package_versions v,",
                 "cran_status s, flavors f,",
                 "identity_merging im, merged_people mp",
                 "WHERE t.id = tv.taskview_id AND tv.id = c.taskview_id",
                 "AND c.package_id = p.id",
                 "AND tv.version = (SELECT max(tv2.version)",
                 "FROM taskview_versions tv2",
                 sprintf("WHERE tv2.version < '%s'", date),
                 "AND tv2.taskview_id = t.id)",
                 sprintf("AND f.name = '%s'", flavor),
                 sprintf("AND s.date = '%s' AND s.flavor_id = f.id", date),
                 "AND s.version_id = v.id AND v.package_id = p.id",
                 "AND im.orig_id = s.maintainer_id AND im.merged_id = mp.id")
  if (!is.null(taskview)) {
    query <- paste(query, sprintf("AND t.name = %s",
                                  FormatString(con, taskview)))
  }
  maintainers <- dbGetQuery(con, query)$maintainer
  FilterGraph(g, maintainers)
}

# TODO make taskview graph
