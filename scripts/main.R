library(devtools)
library(extractoR)

mirrors <- getCRANmirrors()
mirror <- mirrors[mirrors$City == "Bonn", ]$URL
