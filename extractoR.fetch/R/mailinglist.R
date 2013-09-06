FetchMLList <- function(url) {
  # Fetches the list of mailing lists listed on a page.
  #
  # Args:
  #   url: The address of the page listing the mailing list.
  #
  # Returns:
  #   A three column data frame containing the name, description
  #   (desc) and url of each mailing list.
  download.file(url, "listinfo.html", "wget")
  doc = htmlTreeParse("listinfo.html", useInternalNodes=TRUE)
  file.remove("listinfo.html")
  xpathSApply(doc, "//tr", xmlNode)
  urls <- xpathSApply(doc, "//a", xmlAttrs)
  urls <- urls[3:length(urls)]
  lists <- xpathSApply(doc, "//td", xmlValue)
  lists <- lists[7:length(lists)]
  descs <- lists[1:length(lists) %% 2 == 0]
  lists <- lists[1:length(lists) %% 2 == 1]
  data.frame(name=lists, desc=descs, url=urls)
}

FetchML <- function(name, url, maildir) {
  # Downloads the content of a mailing list
  #
  # Args:
  #   name: The name of the mailing list to fetch.
  #   url: The url where the list of mail archives are located.
  #   maildir: The directory where to store the downloaded mail
  #            archives.
  #
  # Returns:
  #   Nothing
  src <- file.path(url, name)
  dest <- sprintf("%s.html", name)
  download.file(src, dest, "wget", extra="--no-check-certificate")
  doc = htmlTreeParse(dest, useInternalNodes=TRUE)
  rm(dest)
  dir.create(file.path(maildir, name))
  todl <- tryCatch(grep("\\.txt(\\.gz)?", xpathSApply(doc, "//a", xmlAttrs),
                        value=TRUE),
                   error=function(e) todl <- character(0))
  sapply(todl, function(x) download.file(file.path(src, x),
                                         file.path(maildir, name, x), "wget",
                                         extra="--no-check-certificate"))
}

FetchRMLList <- function() {
  # Fetches the list of R mailing lists.
  #
  # Returns:
  #   A data frame of mailing lists like the one retuned by
  url <- "https://stat.ethz.ch/mailman/listinfo/"
  FetchMLList(url)
}

FetchRMLContent <- function(ml, maildir) {
  # Downloads the content of R mailing lists
  #
  # Args:
  #   ml: A data frame of mailing lists like the one retuned by
  #       FetchMLList.
  #   maildir: The directory where to store the downloaded mail
  #            archives.
  #
  # Returns:
  #   Nothing
  lapply(tolower(ml$name), FetchML, "https://stat.ethz.ch/pipermail", maildir)
}
