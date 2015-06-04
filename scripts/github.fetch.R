library(extractoR)

datadir <- "/data/github"

## logfile <- "github-download.log"
## basicConfig()
## addHandler(writeToFile, logger="github", file=logfile)

GithubFetch(datadir, cluster=4)
