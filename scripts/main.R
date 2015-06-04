library(extractoR)

datadir <- "/data/cran"
mirrors <- getCRANmirrors()
mirror <- mirrors[mirrors$City == "0-Cloud", ]$URL
