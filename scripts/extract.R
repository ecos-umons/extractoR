library(logging)

datadir <- "/data/rdata/"
basicConfig()

extractoR::ExtractDescriptionFiles(datadir)
extractoR::ExtractDependencies(datadir)
extractoR::ExtractRoles(datadir)
extractoR::ExtractNamespaceFiles(datadir)
extractoR::ExtractPackages(datadir)
