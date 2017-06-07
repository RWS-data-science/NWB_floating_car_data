#init
rm(list=ls(all=TRUE))
source("packages.R")
source("functions.R")

print(paste0("First copy NWB_WEGGEG_COMPLEET dir from P:/civ/RWS_DST/Data_droog to ", getwd(), "/db"))


##############################################################################
#NWB shapefile inlezen
# wegvakken <- readOGR(dsn = paste0(getwd(),"/db/NWB_WEGGEG_COMPLEET/nwb/BN0112-a-Shape-R-U/Wegvakken/Wegvakken.shp"), layer = "Wegvakken") #17-02-2017
# saveRDS(wegvakken, "db/NWB_wegvakken_raw.rds")
wegvakken <- readRDS("db/NWB_wegvakken_raw.rds")

#convert coordinates
#str(coordinates(wegvakken))
wgs <- "+proj=longlat +ellps=WGS84 +datum=WGS84"
wegvakken <- spTransform(wegvakken,wgs) #transform to wgs84
rm(wgs)

#leaflet
#df_map <- head(wegvakken, 1000)
df_map <- wegvakken
m <- leaflet() %>% 
  addTiles() %>%
  addPolylines(data=df_map, color="blue")
m


##############################################################################
#Floating car data inlezen
