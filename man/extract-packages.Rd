\name{Packages}
\alias{Packages}
%% \alias{FilterPackages}
\alias{ExtractPackages}
\encoding{UTF-8}
\title{Packages}
\description{
  Identification of packages in CRAN and Github repositories
}

\usage{
Packages(index, descfile.con, namespace.con)
ExtractPackages(db="rdata", host="mongodb://localhost")
%% FilterPackages(packages)
}
\arguments{
  \item{index}{Repository index.}
  \item{descfile.con}{Connection object to MongoDB DESCRIPTION files.}
  \item{namespace.con}{Connection object to MongoDB NAMESPACE files.}
  %% \item{packages}{Package \code{data.table} such as the one returned by
  %%   \code{FilterPackages}.}
  \item{db}{MongoDB database.}
  \item{host}{MongoDB host.}
}
\value{
  \code{Packages} returns a \code{data.table} with a list of
  repositories, package name and version (if any) and booleans checking
  whether DESCRIPTION and NAMESPACE files are well formatted.

  %% \code{FilterPackages} filters packages returned by \code{Packages} to
  %% only keep the valid ones.

  \code{ExtractPackages} extracts all broken packages information
  missing in MongoDB.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{packages}
\keyword{extract}
