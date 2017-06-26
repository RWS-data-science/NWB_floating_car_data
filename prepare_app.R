

##load data strava
library(rgdal)
ogrListLayers("db/strava_rit.gpx")
strava<- readOGR("db/strava_rit.gpx","tracks")

##save as RData for faster loading
save(strava,file="db/strava.RData")

##laad NWB
#

url<- "https://www.rijkswaterstaat.nl/apps/geoservices/geodata/dmc/nwb-wegen/geogegevens/shapefile/Nederland_totaal/"

library("rvest")
# Get link URLs

main.page <- read_html(url)
folders <- main.page %>% # feed `main.page` to the next step
  html_nodes("td a") %>% # get the CSS nodes
  html_attr("href") 

creation_date <- main.page %>% # feed `main.page` to the next step
  html_nodes("tr td") %>% # get the CSS nodes
  html_text() 

#Select most recent
creation_date<-creation_date[seq(3,length(creation_date),by=4)]
creation_date<- as.POSIXct(creation_date,format="%d-%b-%Y %H:%M")
max<- which.max(creation_date)

download.file(paste0(url,folders[max]), "db/nwb.zip",quiet = T)
unzip("db/nwb.zip",exdir = "db/")

nwb_full<- readOGR("db/01-06-2017/Wegvakken/Wegvakken.shp")


#convert to WGS
rd<- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.999908 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +no_defs"
wgs<- "+proj=longlat +ellps=WGS84 +datum=WGS84"
proj4string(nwb_full)<- rd #definieer de projectie van shapefile
nwb_full_wgs<- spTransform(nwb_full,wgs) #transformeer naar wgs84

##save as RData for faster loading
save(nwb_full_wgs,file="db/nwb_full_wgs.RData")



#load("db/nwb_full_wgs.RData")

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
lines(strava,col="red")


save(nwb_select,file="db/nwb_select.RData")

library(leaflet)
leaflet() %>% addProviderTiles(providers$Esri.WorldStreetMap) %>%
  setView(lng = 4.65, lat = 52.025, zoom = 13) %>%
  addPolylines(data=strava,col="red") %>%
  addPolylines(data=nwb_select,weight = 5, opacity = 1)

