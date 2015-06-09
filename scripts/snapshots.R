library(extractoR.snapshots)
library(logging)

datadir <- "/data/rdata"
basicConfig()

checks <- ListCheckings(file.path(datadir, "cran", "checks"))
system.time(ConvertCSV(checks, datadir))
system.time(snapshots <- SnapshotIndex(datadir))

history <- snapshots[!is.na(version), list(first=min(date), max(date)),
                     by=c("package", "version")]
write.csv(history, file=file.path(datadir, "cran-history.csv"), row.names=FALSE)
