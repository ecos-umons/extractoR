\name{Namespace}
\alias{Namespace}
\alias{ReadCRANNamespace}
\alias{ReadGithubNamespace}
\alias{Namespaces}
\encoding{UTF-8}
\title{Namespace}
\description{
  Extraction of NAMESPACE files content
}

\usage{
ReadCRANNamespace(package, version, datadir)
ReadGithubNamespace(repository, ref, datadir)
Namespaces(index, datadir)
}
\arguments{
  \item{package}{Package name}
  \item{version}{Version of package}
  \item{repository}{Git repository name.}
  \item{ref}{Git repository reference (commit, branch or tag).}
  \item{index}{Repository index.}
  \item{datadir}{Directory where to store and extract the packages.}
}
\value{
  \code{ReadCRANNamespace} reads NAMESPACE file of a CRAN package.

  \code{ReadGithubNamespace} reads NAMESPACE file of a Github R package.

  \code{Namespaces} reads the NAMESPACE file of all packages of
  \code{index}.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{namespace}
\keyword{package}
\keyword{import}
\keyword{export}