GetCRANStatus <- function(con, flavor, date) {
  # Returns the status of CRAN at a given date for a given flavor.
  #
  # Args:
  #   con: The connection object to the database.
  #   flavor: The flavor to get the state.
  #   date: The date of the state to get.
  #
  # Returns:
  #   A four column dataframe containing the package with their
  #   maintainer name, priority and status.
  query <- paste("SELECT p.name package, mp.name maintainer,",
                 "s.priority, s.status",
                 "FROM cran_status s, flavors f, package_versions v,",
                 "packages p, identity_merging im, merged_people mp",
                 sprintf("WHERE f.name = '%s'", flavor),
                 sprintf("AND s.date = '%s' AND s.flavor_id = f.id", date),
                 "AND s.version_id = v.id AND v.package_id = p.id",
                 "AND im.orig_id = s.maintainer_id AND im.merged_id = mp.id")
  dbGetQuery(con, query)
}

GetCRANDeps <- function(con, flavor, date, types=c("depends", "imports")) {
  # Returns all the package dependencies for a given CRAN state.
  #
  # Args:
  #   con: The connection object to the database.
  #   flavor: The flavor to get the state.
  #   date: The date of the state to get.
  #   types: Types of dependencies to get (depends, imports, suggests
  #          and/or enhances).
  #
  # Returns:
  #   A three-column dataframe containing all the depencencies from p1
  #   to p2 and the dependency type.
  types <- do.call(paste, c(lapply(types, function(t) sprintf("'%s'", t)),
                            list(sep=", ")))
  query <- paste("SELECT DISTINCT p.name p1, d.dependency p2",
                 "FROM cran_status s, flavors f, package_versions v,",
                 "packages p, package_dependencies d",
                 sprintf("WHERE f.name = '%s'", flavor),
                 sprintf("AND s.date = '%s' AND s.flavor_id = f.id", date),
                 sprintf("AND type IN (%s)", types),
                 "AND s.flavor_id = f.id AND s.version_id = v.id",
                 "AND v.package_id = p.id AND d.version_id = v.id")
  dbGetQuery(con, query)
}

GetCRANChanges <- function(con, date, flavor=NULL) {
  # Returns the changes of status of CRAN (results of R CMD check) for a
  # given date.
  #
  # Args:
  #   con: The connection object to the database.
  #   date: The date of the state to get.
  #   flavor: The flavor to get the state. If NULL (default) then all
  #           flavors are used.
  # Returns
  #   A dataframe with the changes of CRAN status containing on each
  #   row the name of the maintainer, the flavor name, the package
  #   name, the change type and the old and new value.
  query <- paste("SELECT mp.name maintainer, f.name flavor, p.name package,",
                 "c.type, c.old, c.new",
                 "FROM merged_people mp, identity_merging im, flavors f,",
                 "cran_changes c,",
                 "package_versions v, packages p",
                 "WHERE mp.id = im.merged_id AND im.orig_id = c.maintainer_id",
                 "AND c.flavor_id = f.id",
                 "AND c.version_id = v.id AND v.package_id = p.id",
                 sprintf("AND s.date = '%s'", date))
  if (!is.null(flavor)) {
    query <- paste(query, sprintf("AND f.name = '%s'", flavor))
  }
  dbGetQuery(con, query)
}

base.packages <- c("R", "base", "compiler", "datasets", "graphics",
                   "grDevices", "grid", "methods", "parallel", "profile",
                   "splines", "stats", "stats4", "tcltk", "tools",
                   "translations", "utils")

GetPriority <- function(name, cran) {
  # Returns an integer for a given priority
  #
  # Args:
  #   name: The priority name string.
  #   cran: A dataframe with the state of CRAN to use (like the one
  #         returned by GetCRANState).
  #
  # Returns:
  #   0 for base packages, 1 for recommended and 2 for contributed.
  if (name %in% base.packages) {
    0
  } else if (cran[cran$package == name, ]$priority == "recommended") {
    1
  } else {
    2
  }
}

GetNumVersions <- function(package, con) {
  # Returns the number of versions for a given package.
  #
  # Args:
  #   package: The package name.
  #   con: The connection object to the database
  #
  # Returns:
  #   The number of versions.
  query <- paste("SELECT COUNT(DISTINCT v.id)",
                 "FROM packages p, package_versions v",
                 "WHERE p.name = %s AND p.id = v.package_id")
  dbGetQuery(con, sprintf(query, FormatString(con, package), con))[1, 1]
}

Entropy <- function(x) {
  x <- x / sum(x)
  -sum(x * log(x))
}

PackageEntropy <- function(p, g) {
  Entropy(table(V(g)$maintainer[p]))
}

MaintainerEntropy <- function(m, g) {
  Entropy(table(V(g)$name[m]))
}

MakeDependencyGraph <- function(con, cran, deps) {
  # Makes the depency graph of packages.
  #
  # Args:
  #   con: The connection object to the database
  #   cran: A dataframe with the state of CRAN to use (like the one
  #         returned by GetCRANState).
  #   deps: A dataframe with the packages depenencies (like the one
  #         returned by GetCRANDeps).
  #
  # Returns:
  #   The depenency graph.
  GetMaintainer <- function(p) {
    cran[cran$package == p, ]$maintainer
  }
  packages <- unique(cran$package)
  g <- graph.empty(directed=TRUE) + vertices(packages)
  g <- g + edges(apply(deps[deps$p2 %in% packages, ], 1,
                            function(e) c(e["p1"], e["p2"])))
  V(g)$dependencies <- degree(g, mode="out")
  V(g)$dependents <- degree(g, mode="in")
  V(g)$versions <- sapply(V(g)$name, GetNumVersions, con)
  V(g)$priority <- sapply(V(g)$name, GetPriority, cran)
  V(g)$maintainer <- sapply(V(g)$name, GetMaintainer)
  V(g)$Label <- V(g)$name
  V(g)$entropy <- sapply(get.adjlist(g, mode="in"), PackageEntropy, g)
  g
}

MakeMaintainersGraph <- function(cran, deps) {
  # Makes the dependency graph of package maintainers. In this graph
  # nodes are maintainers and there is an edge between A and B for all
  # packages maintained by A which depend on packages maintained by B.
  #
  # Args:
  #   cran: A dataframe with the state of CRAN to use (like the one
  #         returned by GetCRANState).
  #   deps: A dataframe with the packages depenencies (like the one
  #         returned by GetCRANDeps).
  #
  # Returns:
  #   The maintainers depenency graph.
  GetDep <- function(p1, p2) {
    c(cran[cran$package == p1, "maintainer"],
      cran[cran$package == p2, "maintainer"])
  }
  g <- graph.empty(directed=TRUE) + vertices(unique(cran$maintainer))
  g <- g + edges(apply(deps[deps$p2 %in% cran$package, ], 1,
                       function(e) GetDep(e["p1"], e["p2"])))
  V(g)$packages <- sapply(V(g)$name,
                          function(m) nrow(cran[cran$maintainer == m, ]))
  V(g)$dependencies <- degree(g, mode="out")
  V(g)$dependents <- degree(g, mode="in")
  V(g)$entropy <- sapply(get.adjlist(g, mode="in"), MaintainerEntropy, g)
  V(g)$Label <- V(g)$name
  g
}
