\name{TaskViews}
\alias{ExtractTaskViews}
\alias{ExtractTaskViewsContent}
\encoding{UTF-8}
\title{TaskViews}
\description{
  Those functions are used to convert task views information from ctv
  package to dataframes.
}

\usage{
ExtractTaskViews(cran.mirror="http://cran.r-project.org")
ExtractTaskViewsContent(cran.mirror="http://cran.r-project.org")
}
\arguments{
  \item{cran.mirror}{Root URL of the CRAN mirror to use.}
}
\value{
  \code{ExtractTaskViewsViews} returns a five column data frame
  containing the name of the taskview, its topic, its maintainer name
  and email, and its version.

  \code{ExtractTaskViewsViewsContent} returns a four column dataframe
  containing the name and version of the taskview, the name of the
  package a boolean indicating if it is a core taskview or not.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\examples{
ExtractTaskViews()
ExtractTaskViewsContent()
}

\keyword{taskview}
\keyword{extract}
