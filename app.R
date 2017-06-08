#init
rm(list=ls(all=TRUE))
source("packages.R")
source("functions.R")

print(paste0("First copy NWB_WEGGEG_COMPLEET dir from P:/civ/RWS_DST/Data_droog to ", getwd(), "/db"))


##############################################################################
#NWB shapefile inlezen
# wegvakken <- readOGR(dsn = paste0(getwd(),"/db/NWB_WEGGEG_COMPLEET/nwb/BN0112-a-Shape-R-U/Wegvakken/Wegvakken.shp"), layer = "Wegvakken") #17-02-2017

#convert coordinates
#str(coordinates(wegvakken))
# wgs <- "+proj=longlat +ellps=WGS84 +datum=WGS84"
# wegvakken <- spTransform(wegvakken,wgs) #transform to wgs84
# rm(wgs)

# saveRDS(wegvakken, "db/NWB_wegvakken_raw.rds")
wegvakken <- readRDS("db/NWB_wegvakken_raw.rds")

#leaflet
#df_map <- wegvakken
df_map <- head(wegvakken, 10000)
m <- leaflet() %>% 
  addTiles() %>%
  addPolylines(data=df_map, color="blue")
m


##############################################################################
#Floating car data inlezen
