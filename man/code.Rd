\name{Code}
\alias{Code}
\alias{ParseCode}
\alias{ExtractFunctions}
\alias{ExtractFunctionCalls}
\alias{ExtractCodingStyle}
%% \alias{ResolveFunctionCalls}
\alias{FunctionDefinitions}
\alias{FunctionCalls}
\alias{CodingStyle}
\alias{ParsePackage}
%% \alias{ExplicitCalls}
%% \alias{ImplicitCalls}

\encoding{UTF-8}
\title{Code}
\description{
  Extract informations from packages R code with sourceR.
}

\usage{
ParseCode(datadir, db="rdata", host="mongodb://localhost")
ParsePackage(source, repository, ref, datadir)
ExtractFunctions(datadir, db="rdata", host="mongodb://localhost", cluster.size=6)
FunctionDefinitions(package)
ExtractFunctionCalls(datadir, db="rdata", host="mongodb://localhost", cluster.size=6)
FunctionCalls(package)
%% ExplicitCalls(source, repository, ref, datadir)
%% ImplicitCalls(source, repository, ref, datadir, deps.exports)
ExtractCodingStyle(datadir, db="rdata", host="mongodb://localhost", cluster.size=6)
CodingStyle(package)
%% ResolveFunctionCalls(datadir)
}
\arguments{
  \item{datadir}{Directory where data is stored.}
  \item{db}{MongoDB database.}
  \item{host}{MongoDB host.}
  \item{cluster.size}{Number of cluster nodes to use.}
  \item{source}{Source of the repository.}
  \item{repository}{Repository in which the package is stored.}
  \item{ref}{Reference of the repository to use.}
  \item{package}{\code{package.code} object containing parsed R code of
    a package.}
  %% \item{deps.exports}{Exported function names of the package's depencies.}
}
\value{
  \code{ParsePackage} parses package code and stores result in
  rds files.

  \code{ExtractFunctions}, \code{ExtractFunctionCalls} and
  \code{ExtractCodingStyle} extract function definitions, function calls
  and coding style found inside R packages and store them on disk. These
  functions are run on a cluster of the given size.

  %% \code{ResolveFunctionCalls} extracts the list of function calls that
  %% refer to non core R packages (i.e. explicit calls, calls to a
  %% dependency's function or to the package own's functions).

  \code{ParsePackage} parses the R code of the package found in the
  given repository into
  \code{datadir}/code/\code{source}/\code{repository}/\code{ref}.rds.

  \code{FunctionDefinitions} stores result of
  \code{sourceR::FunctionDefinitions} into
  \code{datadir}/functions/\code{source}/\code{repository}/\code{ref}.rds.

  \code{FunctionCalls} stores result of \code{sourceR::FunctioNCalls}
  into
  \code{datadir}/calls/\code{source}/\code{repository}/\code{ref}.rds.
  %% Explicit calls are the function calls declared directly using the
  %% \code{::} and \code{:::} notation with a package name. Implicit calls
  %% are all the other function calls found in the package for which an
  %% exported function was found in the NAMESPACE file of one of the
  %% dependencies.

  \code{CodingStyle} stores result of \code{sourceR::CodingStyle} into
  \code{datadir}/codingstyle/\code{source}/\code{repository}/\code{ref}.rds.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{code}
\keyword{package}
\keyword{functions}
\keyword{calls}
\keyword{style}
