library(XML)
library(yaml)

pkglist.getlinks <- function(url) {
  doc = htmlTreeParse(url, useInternalNodes=T)
  res <- xpathSApply(doc, "//a[@href]",
                     function(x)list(xmlValue(x), xmlAttrs(x)))
  links <- as.character(res[2,])
  names(links) <- res[1,]
  links
}

pkglist.getversions <- function(url) {
  links <- pkglist.getlinks(url)
  ids <- grep("\\.tar\\.gz$", links)
  versions <- links[ids]
  names(versions) <- sapply(versions, function(x)strsplit(x, "_")[[1]][1])
  versions
}

pkglist.getarchives <- function(url) {
  links <- pkglist.getlinks(url)
  ids <- grep("^[A-Za-z0-9].*/$", links)
  packages <- links[ids]
  names(packages) <- sapply(packages, function(x)substr(x, 1, nchar(x)-1))
  getversions <- function(package) {
    as.character(pkglist.getversions(paste(url, package, sep="")))
  }
  sapply(packages, getversions)
}

pkglist.getpackages <- function(lastversions, archives) {
  getversion <- function(name) {
    strsplit(strsplit(name, "_")[[1]][2], "\\.tar\\.gz")[[1]]
  }
  getversions <- function(package) {
    versions <- union(lastversions[package], archives[[package]])
    versions <- versions[!is.na(versions)]
    as.character(sapply(versions, getversion))
  }
  all.names <- union(names(lastversions), names(archives))
  packages <- lapply(all.names, function(x)
                     list(name=x, notarchived=x %in% lastversions,
                          lastversion=getversion(lastversions[x]),
                          versions=getversions(x)))
  names(packages) <- all.names
  packages
}

pkglist.save <- function(packages, filename) {
  write(as.yaml(packages), file=filename)
}

pkglist.load <- function(filename) {
  yaml.load_file(filename)
}

pkglist.cran <- function(filename) {
  ## url = "http://cran.r-project.org/src/"
  url = "http://cran.r-project.org/src/contrib/"
  lastversions <- pkglist.getversions(url)

  url = "http://cran.r-project.org/src/contrib/Archive/"
  archives <- pkglist.getarchives(url)

  packages <- pkglist.getpackages(lastversions, archives)
  pkglist.save(packages, filename)
  packages
}
