extractoR
=========

extractoR is a set of R packages that can be used to fetch, extract
and dump CRAN packages metadata in a SQL database.

Those R packages are the followings:
* extractoR: main package which act as a glue of functions defined in
  other packages.
* extractoR.utils: utilities functions.
* extractoR.fetch: parses CRAN web pages, downloads and extracts
  packages.
* extractoR.extract: extracts packages metadata in dataframes.
* extractoR.sql.dump: dumps packages metadata to a SQL database
* extractoR.sql.query: queries the SQL database.

The following styleguide is used: https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml
