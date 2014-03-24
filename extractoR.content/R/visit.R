VisitPackages <- function(packages, pkgdir, FUNC, ..., simplify=TRUE) {
  VisitPackage <- function(p) {
    name <- p$package
    version <- p$version
    path <- file.path(pkgdir, name, version, name)
    FUNC(name, version, path, ...)
  }
  by(packages, 1:nrow(packages), VisitPackage, simplify=TRUE)
}
