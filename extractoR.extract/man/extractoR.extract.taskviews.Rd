\name{TaskViews}
\alias{GetTaskViewsDataframe}
\alias{GetTaskViewsContent}
\encoding{UTF-8}
\title{TaskViews}
\description{
  Those functions are used to convert task views information from ctv
  package to dataframes.
}

\usage{
GetTaskViewsDataframe(cran.mirror="http://cran.r-project.org")
GetTaskViewsContent(cran.mirror="http://cran.r-project.org")
}
\arguments{
  \item{cran.mirror}{Root URL of the CRAN mirror to use.}
}
\value{
  \code{GetTaskViewsDataframe} returns a five column data frame
  containing the name of the taskview, its topic, its maintainer name
  and email, and its version

  \code{GetTaskViewsContent} returns a four column dataframe containing
  the name and version of the taskview, the name of the package a
  boolean indicating if it is a core taskview or not.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\examples{
GetTaskViewsDataframe()
GetTaskViewsContent()
}

\keyword{parse}
\keyword{archive}
\keyword{name}
\keyword{package}