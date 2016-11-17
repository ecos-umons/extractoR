\name{RData}
\alias{RData}
\alias{SaveRData}
\alias{LoadRData}
\alias{SaveCSV}
\alias{LoadCSV}
\alias{LoadFastCSV}
\alias{SaveYAML}
\alias{LoadYAML}
\alias{SaveJSON}
\alias{LoadJSON}
\alias{SaveFeather}
\alias{LoadFeather}
\encoding{UTF-8}
\title{RData}
\description{
  Saves and loads object containing informations extracted by extractoR.
}

\usage{
SaveRData(rdata, datadir, subdir=".", format="rds",
          FUNC=saveRDS, FILTER=base::identity, ...)
LoadRData(datadir, subdir=".", format="rds",
          FUNC=readRDS, FILTER=base::identity, ...)
SaveCSV(rdata, datadir, subdir=".", FILTER=base::identity)
LoadCSV(datadir, subdir=".", FILTER=base::identity)
LoadFastCSV(datadir, subdir=".", FILTER=base::identity)
SaveYAML(rdata, datadir, subdir=".", FILTER=base::identity)
LoadYAML(datadir, subdir=".", FILTER=base::identity)
SaveJSON(rdata, datadir, subdir=".", FILTER=base::identity)
LoadJSON(datadir, subdir=".", FILTER=base::identity, ...)
SaveFeather(rdata, datadir, subdir=".", FILTER=base::identity)
LoadFeather(datadir, subdir=".", FILTER=base::identity)
}
\arguments{
  \item{rdata}{A list containing objects to be saved}
  \item{datadir}{Directory where to save/load objects}
  \item{subdir}{Subdirectory where to save/load objects}
  \item{format}{Format used to save/load \code{data.table} objects}
  \item{FUNC}{Function used to read/write from file}
  \item{FILTER}{Function used to filter the files to read/write}
  \item{...}{Additional arguments to pass to \code{FUNC}}
}
\value{
  \code{SaveRData} saves elements each element of a list. By default
  saves to RDS file.

  \code{LoadRData} reads all files and returns a list where all
  elements are the objects contained into the data files. By default
  loads RDS files.

  \code{SaveCSV}, \code{SaveYAML}, \code{SaveJSON}, \code{SaveFeather},
  \code{LoadCSV}, \code{LoadYAML}, \code{LoadJSON} and
  \code{LoadFeather} call \code{SaveRData} and \code{LoadRData} with
  parameters to save/load data to CSV, YAML, JSON and Feather formats.

  \code{LoadFastCSV} loads data from CSV files using \code{data.table}'s
  \code{fread} function.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{data}
\keyword{save}
\keyword{load}
\keyword{rds}
\keyword{csv}
\keyword{feather}