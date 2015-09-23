library(extractoR.snapshots)
library(logging)

datadir <- "/data/rdata"
basicConfig()

checks <- ListCheckings(file.path(datadir, "cran", "checks"))
system.time(ConvertCSV(checks, datadir))
## system.time(flavors <- dcast(FlavorHistory(datadir), date ~ flavor))

flavors <- list("release-linux"="r-release-linux-x86_64",
                "release-windows"="r-release-windows-ix86+x86_64",
                "patched-solaris"=c("r-patched-solaris-x86_64",
                  "r-prerel-solaris-x86_64"),
                "oldrel-windows"="r-oldrel-windows-ix86+x86_64",
                "devel-windows"="r-devel-windows-ix86+x86_64",
                "devel-osx"=c("r-devel-macosx-x86_64",
                  "r-devel-macosx-x86_64-clang", "r-devel-osx-x86_64-clang"),
                "devel-debian-gcc"=c("r-devel-linux-x86_64-debian",
                  "r-devel-linux-x86_64-debian-gcc"),
                "devel-debian-clang"=c("r-devel-linux-x86_64-debian",
                  "r-devel-linux-x86_64-debian-clang"),
                "devel-fedora-clang"="r-devel-linux-x86_64-fedora-clang",
                "devel-fedora-gcc"="r-devel-linux-x86_64-fedora-gcc")

system.time(for (name in names(flavors)) {
  print(name)
  system.time(snapshots <- CRANCheckHistory(datadir, flavors=flavors[[name]],
                                            filename=name)
})
