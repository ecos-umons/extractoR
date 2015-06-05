\name{TaskViews}
\alias{ExtractTaskViews}
\encoding{UTF-8}
\title{TaskViews}
\description{
  Those functions are used to convert task views information from ctv
  package to data.table.
}

\usage{
ExtractTaskViews(cran.mirror="http://cran.r-project.org")
}
\arguments{
  \item{cran.mirror}{Root URL of the CRAN mirror to use.}
}
\value{
  \code{ExtractTaskViewsViews} returns the content of task views as a
  \code{data.table} with the name of the task view, its topic, its
  maintainers, the contact e-mail address, its version, the URL of the
  repository, the name of package and a boolean that is TRUE iff the
  package is considered a core package in the task view.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\examples{
ExtractTaskViews()
}

\keyword{taskview}
\keyword{extract}
