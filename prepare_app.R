

##load data strava
library(rgdal)
ogrListLayers("db/strava_rit.gpx")
strava<- readOGR("db/strava_rit.gpx","tracks")

##save as RData for faster loading
save(strava,file="db/strava.RData")

##laad NWB
nwb_full<- readOGR("db/01-06-2017 2/Wegvakken/Wegvakken.shp")

#convert to WGS
rd<- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.999908 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +no_defs"
wgs<- "+proj=longlat +ellps=WGS84 +datum=WGS84"
proj4string(nwb_full)<- rd #definieer de projectie van shapefile
nwb_full_wgs<- spTransform(nwb_full,wgs) #transformeer naar wgs84

##save as RData for faster loading
save(nwb_full_wgs,file="db/nwb_full_wgs.RData")



load("db/nwb_full_wgs.RData")

##clip nwb 
xmin<- 4.6
xmax<- 4.7
ymin<- 52.0
ymax<- 52.05
coords = matrix(c(xmin, ymin,
                  xmax, ymin,
                  xmax, ymax,
                  xmin, ymax), 
                ncol = 2, byrow = TRUE)


P1 = Polygon(coords)

Ps1 = SpatialPolygons(list(Polygons(list(P1), ID = "a")), proj4string=CRS(wgs))


library(rgeos)
nwb_select<- nwb_full_wgs[Ps1,]
plot(Ps1, axes = TRUE)
lines(nwb_select)


save(nwb_select,file="db/nwb_select.RData")


leaflet() %>% addProviderTiles(providers$Esri.WorldStreetMap) %>%
  setView(lng = 4.65, lat = 52.025, zoom = 13) %>%
  addPolylines(data=strava,col="red") %>%
  addPolylines(data=nwb_select,weight = 5, opacity = 1)

