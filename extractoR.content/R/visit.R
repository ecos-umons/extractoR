PackageRDSFile <- function(data) {
  sprintf("%s.rds", paste(data$package, data$version, sep="_"))
}

PackageFromRDSFile <- function(file) {
  re <- "^(.*)_(.*)\\.rds$"
  data.frame(name=sub(re, "\\1", file), version=sub(re, "\\2", file))
}

VisitPackages <- function(packages, pkg.dir, FUNC, ..., simplify=TRUE) {
  VisitPackage <- function(p) {
    name <- p$package
    version <- p$version
    path <- file.path(pkg.dir, name, version, name)
    message(sprintf("Visiting %s %s content", name, version))
    FUNC(name, version, path, ...)
  }
  by(packages, 1:nrow(packages), VisitPackage, simplify=simplify)
}

BrowseFunctions <- function(packages, pkg.dir, func.dir, log.dir=NULL) {
  fcode <- function(data) {
    saveRDS(FindFunctions(data$code),
            file.path(func.dir, PackageRDSFile(data)))
    list(res="code")
  }

  ferr <- function(data) {
    message(data$err)
    filename <- sprintf("%s.rds", paste(data$package, data$version, sep="_"))
    if (!is.null(log.dir)) {
      saveRDS(data$err, file.path(log.dir, PackageRDSFile(data)))
    }
    list(res="err", data=data)
  }

  fnull <- function(data) {
    saveRDS(data.table(), file.path(func.dir, PackageRDSFile(data)))
    list(res="nocode")
  }

  done <- union(dir(func.dir), dir(log.dir))
  packages <- packages[!PackageRDSFile(packages) %in% done, ]
  if (nrow(packages)) {
    res <- VisitPackages(packages, pkg.dir, extractoR.content::ParsePackage,
                         fcode, fnull, ferr, simplify=FALSE)
    names(res) <- paste(packages$package, packages$version)
    res
  } else list()
}
