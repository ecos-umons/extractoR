extractoR
=========

extractoR is a set of R packages that can be used to fetch, extract
and dump CRAN packages metadata.

Those R packages are the followings:
* extractoR: main package which act as a glue for functions defined in
  other packages.
* extractoR.utils: utilities functions.
* extractoR.fetch: parses CRAN web pages, downloads and extracts
  packages.
* extractoR.extract: extracts packages metadata in dataframes.
* extractoR.sql: exports data to SQL databases.
* extractoR.checkings: contains functions to read and insert in SQL
  table results of "R CMD check" commands run on CRAN (see
  http://cran.r-project.org/web/checks/). It requires that one
  manually download the files check_flavors.rds, check_details.rds and
  check_results.rds and then store them in a directory which name is
  based on the date of extraction (using the format "%y-%m-%d-%H-%M").
  Ideally this manual extraction should be automated with a cron job
  to keep an history of this check results.



Coding rules
------------

The following styleguide is used for R code:
https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml
