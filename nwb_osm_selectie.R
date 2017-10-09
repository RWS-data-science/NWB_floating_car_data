library(data.table)

#basemap<- readOGR("db/basemaps/13354-shapes/segments.shp")
#save(basemap,file="db/basemap_full.RData")
load("db/basemap.RData")

#load nwb
load("db/nwb_full_wgs.RData")

wgs<- "+proj=longlat +ellps=WGS84 +datum=WGS84"
nwb_full<- spTransform(nwb_full,wgs)

##clip nwb 
xmin<- 5.07
xmax<- 5.11
ymin<- 52.04
ymax<- 52.07
coords = matrix(c(xmin, ymin,
                  xmax, ymin,
                  xmax, ymax,
                  xmin, ymax), 
                ncol = 2, byrow = TRUE)


#maak een vierkant tbv selectie
P1 = Polygon(coords)
wgs<- "+proj=longlat +ellps=WGS84 +datum=WGS84"
Ps1 = SpatialPolygons(list(Polygons(list(P1), ID = "a")), proj4string=CRS(wgs))
proj4string(basemap)<- wgs

library(rgeos)
nwb_select<- nwb_full[Ps1,]
basemap_select<- basemap[Ps1,]

save(nwb_select,file="db/nwb_selectie_Utrecht.RData")
save(basemap_select,file="db/basemap_selectie_Utrecht.RData")

#save(basemap_select,file="db/basemap_select.RData")

