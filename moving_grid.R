library(data.table)
library(rgeos)

#laad basemap
#basemap<- readOGR("db/basemaps/13354-shapes/segments.shp")
#save(basemap,file="db/basemap.RData")
load("db/basemap.RData")

wgs<- "+proj=longlat +ellps=WGS84 +datum=WGS84"
proj4string(basemap)<- wgs

#load nwb



nwb_full<- readOGR("db/NWB/01-06-2017/Wegvakken/Wegvakken.shp")
rd<- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.999908 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +no_defs"

#proj4string(nwb_full)<- rd
#nwb_full<- spTransform(nwb_full,rd)
#save(nwb_full,file="db/nwb_full_wgs.RData")
load("db/nwb_full_wgs.RData")


minlon <- 3.30
maxlon <- 7.18
loninc <- 0.02

minlat <- 50.72
maxlat <- 53.48
latinc <- 0.02


lons<- seq(minlon,maxlon,by=loninc)
lats<- seq(minlat,maxlat,by=latinc)

marge<- 0.001

for (i in 1:length(lons)){
  for (j in 1:length(lats)){
  
  xmin<- lons[i]-marge
  xmax<- lons[i]+loninc + marge
  ymin<- lats[j]-marge
  ymax<- lats[j]+latinc+marge
  coords = matrix(c(xmin, ymin,
                    xmax, ymin,
                    xmax, ymax,
                    xmin, ymax), 
                  ncol = 2, byrow = TRUE)
  
  #maak een vierkant tbv selectie
  P1 = Polygon(coords)
  
  Ps1 = SpatialPolygons(list(Polygons(list(P1), ID = "a")), proj4string=CRS(wgs))
  
  
  
  nwb_select<- nwb_full_wgs[Ps1,]
  basemap_select<- basemap[Ps1,]
  
  
  
  }
}


