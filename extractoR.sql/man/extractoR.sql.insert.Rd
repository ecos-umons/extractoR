\name{Insert}
\alias{Insert}
\alias{InsertPackages}
\alias{InsertVersions}
\alias{InsertPeople}
\alias{InsertDescfiles}
\alias{InsertRoles}
\alias{InsertDependencies}
\alias{InsertDependencyConstraints}
\alias{InsertDates}
\alias{InsertRVersions}
\alias{InsertTaskViews}
\alias{InsertTaskViewVersions}
\alias{InsertTaskViewContent}
\encoding{UTF-8}
\title{Insert}
\description{
  Functions used to insert extractoR.extract's dataframes into SQL
  tables.
}

\usage{
InsertPackages(con, packages)
InsertVersions(con, versions)
InsertPeople(con, people)
InsertDescfiles(con, descfiles)
InsertRoles(con, roles)
InsertDependencies(con, dependencies)
InsertDependencyConstraints(con, constraints)
InsertDates(con, dates)
InsertRVersions(con, rversions)
InsertTaskViews(con, taskviews)
InsertTaskViewVersions(con, versions)
InsertTaskViewContent(con, content)
}
\arguments{
  \item{con}{Connection object to the database.}
  \item{packages}{Packages dataframe.}
  \item{versions}{Package or taskview versions dataframe.}
  \item{people}{People dataframe.}
  \item{descfiles}{DESCRIPTION files dataframe.}
  \item{roles}{Roles dataframe.}
  \item{dependencies}{Dependencies dataframe.}
  \item{constraints}{Constraints dataframe.}
  \item{dates}{Dates dataframe.}
  \item{rversions}{RVersions dataframe.}
  \item{taskviews}{Taskviews dataframe.}
  \item{content}{Taskview content dataframe.}
}
\details{
  Inserts into tables packages, package_versions, description_files,
  roles, package_dependencies, dependency_constraints, dates, rversions.

  Function related to taskviews insert in tables taskviews,
  taskview_versions and taskview_content.
}

\author{
  Maëlick Claes <himself@maelick.net>
}

\keyword{insert}
\keyword{sql}
