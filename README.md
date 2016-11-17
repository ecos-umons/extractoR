[![Build Status](https://travis-ci.org/ecos-umons/extractoR.svg?branch=master)](https://travis-ci.org/ecos-umons/extractoR)

extractoR
=========

extractoR is a R package that can be used to fetch, extract and dump R
packages metadata from CRAN and GitHub into MongoDB.

It contains function to:
* Get the list of raw packages from CRAN and download their archive;
* From a list of GitHub repositories, list those that are packages and
  parse them;
* Store in MongoDB an index of CRAN and GitHub packages.
* Read Metadata (DESCRIPTION and NAMESPACE files) from CRAN and GitHub
  packages, parses roles and dependencies from DESCRIPTION and store
  the results in MongoDB;
* Parse R code from packages, list function definitions and function
  calls;
* Read results of "R CMD check" commands run on CRAN (see
  http://cran.r-project.org/web/checks/). It requires that one
  manually download the files check_flavors.rds, check_details.rds and
  check_results.rds and then store them in a directory which name is
  based on the date of extraction (using the format "%y-%m-%d-%H-%M").
  Ideally this manual extraction should be automated with a cron job
  to keep an history of this check results.



Installation
------------

With devtools package:

    devtools::install_github("ecos-umons/extractoR")



Usage
-----

The sub directory "scripts" contains simple example scripts which can
be reused for various tasks.

There is also functions to parse information related to CRAN state and
checking (http://cran.r-project.org/web/checks/). However this
requires to regularly (e.g. daily) run a script which will extract a
snapshot of CRAN "R CMD check" results. Such a script can be found in
[CRANData](https://github.com/maelick/CRANData).



Coding rules
------------

The following styleguide is used for R code format:
https://google.github.io/styleguide/Rguide.xml
