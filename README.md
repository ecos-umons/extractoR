extractoR
=========

extractoR is a set of R packages that can be used to fetch, extract
and dump CRAN packages metadata.

Those R packages are the followings:
* extractoR: main package which act as a glue for functions defined in
  other packages.
* extractoR.utils: placeholder for helper functions used across
  different packages.
* extractoR.fetch contains functions to fetch raw data from CRAN. Main
  functions are used to get the list of available packages, download
  these packages and extract them on local disk. Future versions will
  include mailing list fetching.
* extractoR.extract contains functions to read data extracted with
  extractoR.fetch and parse them.. Most of those functions return data
  frames.
* extractoR.sql contains functions related to SQL database. Its main
  purpose is to store dataframes created by extractoR.extract into SQL
  tables.
* extractoR.checkings contains functions to read and insert in SQL
  table results of "R CMD check" commands run on CRAN (see
  http://cran.r-project.org/web/checks/). It requires that one
  manually download the files check_flavors.rds, check_details.rds and
  check_results.rds and then store them in a directory which name is
  based on the date of extraction (using the format "%y-%m-%d-%H-%M").
  Ideally this manual extraction should be automated with a cron job
  to keep an history of this check results.
 * extractoR.content contains functions to read package content.



Installation
------------

To install the packages one can either use the install.R script
provided in the root directory of extractoR repo:

    > git clone https://github.com/maelick/extractoR
    > cd extractoR
    > Rscript install.R

It can also be installed directly from the R interpreter using the
devtools package to automatically fetch last Github release:

    install_github("maelick/extractoR", subdir="extractoR")
    install_github("maelick/extractoR", subdir="extractoR.utils")
    install_github("maelick/extractoR", subdir="extractoR.fetch")
    install_github("maelick/extractoR", subdir="extractoR.extract")
    install_github("maelick/extractoR", subdir="extractoR.sql")
    install_github("maelick/extractoR", subdir="extractoR.checkings")
    install_github("maelick/extractoR", subdir="extractoR.content")



Usage
-----

The sub directory "scripts" contains simple example scripts which can
be reused for various tasks. Here's an example of code which downloads
all packages (may be very long...) and dumps everything in a MySQL
database. Before running the script, the database must be initialized
with the schema given in the "db" directory. Then the script will
fetch the list of packages and download all packages inside the
packages subdirectory in data directory, then extract information
about packages, versions, maintainers, dates and dependencies in RDS
files in data/rds. Finally it inserts this information in MySQL
tables.

    library(extractoR)

    FetchAll("data")
    ExtractAll("data")

    dbuser <- "user"
    dbpass <- "password"
    dbname <- "rdata"

    con <- dbConnect(MySQL(), user=dbuser, password=dbpass, dbname=dbname)
    dbClearResult(dbSendQuery(con, "SET NAMES utf8"))
    dbClearResult(dbSendQuery(con, "SET collation_connection=utf8_bin"))
    dbClearResult(dbSendQuery(con, "SET collation_server=utf8_bin"))

    rdata <- LoadRData("data/rds")

    InsertAll(con, rdata)

There are also functions to extract task views (using ctv package) and
HTTP log of mirrors (like the one provided by the RStudio mirror).
There is also functions to insert in the DB information related to
CRAN state and checking (http://cran.r-project.org/web/checks/).
However this requires to regularly (e.g. daily) run a script which
will extract a snapshot of CRAN "R CMD check" results. Such a script
can be found in [CRANData](https://github.com/maelick/CRANData).



CRAN Data
---------

[CRANData](https://github.com/maelick/CRANData) repository the data we
previously extracted (starting in September 2013). It contains both
all RDS files resulting from the extraction of CRAN packages with
extractoR and a daily snapshot of
[CRAN R CMD check results](http://cran.r-project.org/web/checks/).



Coding rules
------------

The following styleguide is used for R code:
https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml
