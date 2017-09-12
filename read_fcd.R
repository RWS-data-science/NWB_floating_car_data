library(data.table)

basemap<- readOGR("db/basemaps/13354-shapes/segments.shp")


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


#maak een vierkant tbv selectie
P1 = Polygon(coords)
wgs<- "+proj=longlat +ellps=WGS84 +datum=WGS84"
Ps1 = SpatialPolygons(list(Polygons(list(P1), ID = "a")), proj4string=CRS(wgs))
proj4string(basemap)<- wgs

library(rgeos)
nwb_select<- nwb_full_wgs[Ps1,]
basemap_select<- basemap[Ps1,]

#save(basemap_select,file="db/basemap_select.RData")



###OUD#####

# #plot(Ps1, axes = TRUE)
# #lines(nwb_select)
# #save(nwb_select,file="db/nwb_select2.RData")
# 
# #convert FCD to spatial lines
# 
# basemap_select<- basemap[which(basemap$BeginNodeLatitude<= ymax & basemap$BeginNodeLatitude>= ymin &
#                                  basemap$BeginNodeLongitude<= xmax & basemap$BeginNodeLongitude>= xmin),]
# 
# 
# begin.coord <- data.frame(lon=basemap_select$BeginNodeLongitude, lat=basemap_select$BeginNodeLatitude)
# end.coord <- data.frame(lon= basemap_select$EndNodeLongitude, lat=basemap_select$EndNodeLatitude)
# 
# library(spatstat)
# p <- psp(begin.coord[,1], begin.coord[,2], end.coord[,1], end.coord[,2],     owin(range(c(begin.coord[,1], end.coord[,1])), range(c(begin.coord[,2], end.coord[,2]))))
# 
# library(maptools)
# l<-as(p, "SpatialLines") 
# 
# Sldf <- SpatialLinesDataFrame(l, data = basemap_select)
# #save(Sldf,file="db/fcd_select.RData")
# 
# library(leaflet)
# leaflet() %>% addTiles()  %>% addPolylines(data=Sldf,col="red",popup= ~paste("SegmentID:",SegmentID, "<br>",
#                                                                        "OptimalSpeedKPH: ",OptimalSpeedKPH)) %>% 
#   addPolylines(data=nwb_select,popup=~paste("WVK_ID: ",WVK_ID))
# 
# 
# ####laad minuutdata
# fcd_samp<- read.table("db/fcd-wetransfer/09-01-15-000-d47c9fb0ee806c0982f1a2d1dbd90f47f45d10df.txt",
#                       sep=";",skip = 1,header = T)
# 
# ggplot(fcd_samp,aes(x=SpeedKph))+geom_histogram(binwidth = 5,col="black")
# ggplot(fcd_samp,aes(x=Coverage))+geom_histogram(binwidth = 1,col="black")
# ggplot(fcd_samp,aes(x=Coverage,y=SpeedKph))+geom_hex()
