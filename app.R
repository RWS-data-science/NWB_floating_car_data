#init
rm(list=ls(all=TRUE))
source("packages.R")
source("functions.R")

print(paste0("First copy NWB_WEGGEG_COMPLEET dir from P:/civ/RWS_DST/Data_droog to ", getwd(), "/db"))

#NWB shapefile inlezen (31-12-2016)
# wegvakken <- readOGR(dsn = paste0(getwd(),"/db/NWB_WEGGEG_COMPLEET/nwb/BN0112-a-Shape-R-U/Wegvakken/Wegvakken.shp"), layer = "Wegvakken")
# wegvakken <- as.data.frame(wegvakken)
# saveRDS(wegvakken, "db/NWB_wegvakken_raw.rds")
wegvakken <- readRDS("db/NWB_wegvakken_raw.rds")

