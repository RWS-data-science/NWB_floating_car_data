library(data.table)

basemap<- fread("fcd-wetransfer/basemap_13347/segments-static.csv")


#load nwb
load("db/nwb_full_wgs.RData")

##clip nwb 
xmin<- 4.65
xmax<- 4.7
ymin<- 52.0
ymax<- 52.05
coords = matrix(c(xmin, ymin,
                  xmax, ymin,
                  xmax, ymax,
                  xmin, ymax), 
                ncol = 2, byrow = TRUE)


P1 = Polygon(coords)
wgs<- "+proj=longlat +ellps=WGS84 +datum=WGS84"
Ps1 = SpatialPolygons(list(Polygons(list(P1), ID = "a")), proj4string=CRS(wgs))


library(rgeos)
nwb_select<- nwb_full_wgs[Ps1,]
plot(Ps1, axes = TRUE)
lines(nwb_select)


#convert FCD to spatial lines

basemap_select<- basemap[which(basemap$BeginNodeLatitude<= ymax & basemap$BeginNodeLatitude>= ymin &
                                 basemap$BeginNodeLongitude<= xmax & basemap$BeginNodeLongitude>= xmin),]


begin.coord <- data.frame(lon=basemap_select$BeginNodeLongitude, lat=basemap_select$BeginNodeLatitude)
end.coord <- data.frame(lon= basemap_select$EndNodeLongitude, lat=basemap_select$EndNodeLatitude)

library(spatstat)
p <- psp(begin.coord[,1], begin.coord[,2], end.coord[,1], end.coord[,2],     owin(range(c(begin.coord[,1], end.coord[,1])), range(c(begin.coord[,2], end.coord[,2]))))

library(maptools)
l<-as(p, "SpatialLines") 

library(leaflet)
leaflet() %>% addTiles()  %>% addPolylines(data=l,col="red") %>% addPolylines(data=nwb_select)



