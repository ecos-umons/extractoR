extractoR
=========

extractoR is a set of R packages that can be used to fetch, extract
and dump R package metadata.

Those R packages are the followings:
* extractoR: main package which act as a glue for functions defined in
  other packages.
* extractoR.cran contains functions to fetch raw data from CRAN. Main
  functions are used to get the list of available packages, download
  these packages and extract them on local disk.
* extractoR.github contains functions to fetch R package repositories
  data from Github.
* extractoR.data contains functions to read, manipulate and export R
  packages metadata.
* extractoR.extract contains functions to read data extracted with
  extractoR.fetch and parse them. Most of these functions return
  data.table objects.
* extractoR.snapshots contains functions to read results of "R CMD
  check" commands run on CRAN (see
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

    install_github("maelick/extractoR", subdir="extractoR.cran")
    install_github("maelick/extractoR", subdir="extractoR.github")
    install_github("maelick/extractoR", subdir="extractoR.extract")
    install_github("maelick/extractoR", subdir="extractoR.data")
    install_github("maelick/extractoR", subdir="extractoR.snapshots")
    install_github("maelick/extractoR", subdir="extractoR.content")
    install_github("maelick/extractoR", subdir="extractoR")



Usage
-----

The sub directory "scripts" contains simple example scripts which can
be reused for various tasks.

There is also functions to parse information related to CRAN state and
checking (http://cran.r-project.org/web/checks/). However this
requires to regularly (e.g. daily) run a script which will extract a
snapshot of CRAN "R CMD check" results. Such a script can be found in
[CRANData](https://github.com/maelick/CRANData).



CRAN Data
---------

[CRANData](https://github.com/maelick/CRANData) repository the data we
previously extracted (starting in September 2013). It contains both
all RDS files resulting from the extraction of CRAN packages with
extractoR and a daily snapshot of
[CRAN R CMD check results](http://cran.r-project.org/web/checks/).



Coding rules
------------

The following styleguide is used for R code format:
https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml
