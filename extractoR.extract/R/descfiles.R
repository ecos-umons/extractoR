GetDescfileName <- function(package, version, datadir) {
  # Returns the file name of a DESCRIPTION file.
  #
  # Args:
  #   package: The package name.
  #   version: The package version.
  #   datadir: The directory where are stored packages content.
  #
  # Returns:
  #   The file name of the DESCRIPTION file.
  file.path(datadir, package, version, package, "DESCRIPTION")
}

GuessEncoding <- function(filename) {
  # Guesses the encoding of a file.
  #
  # Args:
  #   filename: The name of the file to guess the encoding.
  #
  # Returns:
  #   The encoding of the file.
  cmd <- sprintf("file --mime-encoding %s", filename)
  strsplit(system(cmd, intern=TRUE), " ")[[1]][2]
}

ReadDescfile <- function(package, version, datadir) {
  # Reads and parses the DESCRIPTION file of all packages.
  #
  # Args:
  #   package: The package name.
  #   version: The package version.
  #   datadir: The directory where are stored packages content.
  #
  # Returns:
  #   A four column dataframe with package name, version, DESCRIPTION
  #   file keys and values.
  message(sprintf("Reading DESCRIPTION file %s %s", package, version))
  name <- GetDescfileName(package, version, datadir)
  if (file.exists(name)) {
    descfile <- read.dcf(name)
    values <- as.vector(descfile[1, ])
    encoding <- GuessEncoding(name)
    if ("Encoding" %in% colnames(descfile)) {
      encoding <- descfile[colnames(descfile) == "Encoding"]
    }
    values <- iconv(as.vector(descfile[1, ]), encoding, "utf8")
    n <- ncol(descfile)
    data.frame(package=rep(package, n), version=rep(version, n),
               key=colnames(descfile), value=values, stringsAsFactors=FALSE)
  } else NULL
}

ReadDescfiles <- function(packages, datadir) {
  # Reads and parses the DESCRIPTION file of all packages.
  #
  # Args:
  #   packages: A dataframe containing packages (like the one returned
  #             by GetPackagesDataframe).
  #   datadir: The directory where are stored packages content.
  #
  # Returns:
  #   A four column dataframe with packages name, version, DESCRIPTION
  #   files keys and values.
  descfiles <- apply(packages, 1,
                     function(p) ReadDescfile(p["package"], p["version"],
                                              datadir))
  dflist2df(descfiles)
}

GetDescfilesKeys <- function(descfiles) {
  # Returns all the keys of a dataframe of DESCRIPTION files.
  #
  # Args:
  #   descfiles: A dataframe containing DESCRIPTION files (like the
  #              one returned by ReadDescFiles)
  #
  # Returns:
  #   A vector of DESCRIPTION file keys.
  unique(descfiles$key)
}

GetDescfilesKey <- function(descfiles, key) {
  # Returns all the rows of a dataframe where there is a key match.
  #
  # Args:
  #   descfiles: A dataframe containing DESCRIPTION files (like the
  #              one returned by ReadDescFiles)
  #   key: The key to match.
  #
  # Returns:
  #   A sub dataframe thus giving all packages and versions having the
  #   key defined and the associated value.
  descfiles[descfiles$key==key,]
}
