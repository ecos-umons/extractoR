\name{Graph}
\alias{Graph}
\alias{MakeDependencyGraph}
\alias{MakeMaintainersGraph}
\alias{AddPackagesGraphCheckings}
\alias{AddMaintainersGraphCheckings}
\alias{AddMaintainersGraphPackagesCheckings}
\alias{AddMaintainersGraphRelativePackagesCheckings}
\encoding{UTF-8}
\title{Graph}
\description{
  Functions used to insert extractoR.extract's dataframes into SQL
  tables.
}

\usage{
MakeDependencyGraph(con, cran, deps)
MakeMaintainersGraph(cran, deps)
AddPackagesGraphCheckings(g, checkings)
AddMaintainersGraphCheckings(g, checkings)
AddMaintainersGraphPackagesCheckings(g, checkings)
AddMaintainersGraphRelativePackagesCheckings(g, checkings)

}
\arguments{
  \item{cran}{A dataframe with the state of CRAN to use (like the one
    returned by \code{GetCRANState}).}
  \item{deps}{A dataframe with the packages depenencies (like the one
    returned by \code{GetCRANDeps}).}
  \item{g}{A dependency graph (either for packages or maintainers).}
  \item{checkings}{A dataframe with the error checkings of CRAN (like
    the one returned by \code{GetCRANCheckings}).}
  \item{con}{Connection object to the database.}
}
\value{
  \code{MakeDependencyGraph} makes the depency graph of packages.

  \code{MakeMaintainersGraph} Makes the dependency graph of package
  maintainers. In this graph nodes are maintainers and there is an edge
  between A and B for all packages maintained by A which depend on
  packages maintained by B.

  \code{AddPackagesGraphCheckings} adds number of errors, warnings and
  notes to each nodes in the package dependencies graph.

  \code{AddMaintainersGraphCheckings} adds number of errors, warnings
  and notes to each nodes in the maintainers dependencies graph.

  \code{AddMaintainersGraphPackagesCheckings} adds number of packages
  with errors, warnings and notes to each nodes in the maintainers
  dependencies graph.

  \code{AddMaintainersGraphRelativePackagesCheckings} adds relative
  number of packages with errors, warnings and notes to each nodes in
  the maintainers dependencies graph.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{graph}
\keyword{dependencies}
\keyword{cran}
