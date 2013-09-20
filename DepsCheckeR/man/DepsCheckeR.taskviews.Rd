\name{TaskViews}
\alias{TaskViews}
\alias{GetTaskViewPackagesGraph}
\alias{GetTaskViewMaintainersGraph}
\encoding{UTF-8}
\title{TaskViews}
\description{
  Functions used to make task view related graphs.
}

\usage{
GetTaskViewPackagesGraph(con, g, date, taskview=NULL)
GetTaskViewMaintainersGraph(con, g, date, flavor, taskview=NULL)
}
\arguments{
  \item{con}{Connection object to the database.}
  \item{g}{The dependency graph object.}
  \item{date}{The date to use as taskviews version number.}
  \item{taskview}{The taskview to use (if NULL uses all taskviews).}
  \item{flavor}{The flavor to use.}
}
\value{
  \code{GetTaskViewPackagesGraph} returns the depdency graph for a given
  taskviews.

  \code{GetTaskViewMaintainersGraph} returns the maintainers depdency
  graph for a given taskview
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{taskviews}
\keyword{graph}
\keyword{dependencies}
\keyword{cran}
