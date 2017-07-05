#osm

library("osmar")

xmin<- 4.69
xmax<- 4.7
ymin<- 52.0
ymax<- 52.05

box <- corner_bbox(xmin,ymin,xmax,ymax)
(xmax-xmin)*(ymax-ymin)

osm<- get_osm(box,source = osmsource_api())

class(osm$ways)

#extract ways
hw_ids <- find(osm, way(tags(k == "highway")))
hw_ids <- find_down(osm, way(hw_ids))

ts <- subset(osm, ids = hw_ids)

osm_ways<- as_sp(ts, what = "lines")
#      crs = osm_crs(), simplify = TRUE)

library(leaflet)
leaflet() %>% addTiles() %>% addPolylines(data=osm_ways)


leaflet() %>% addTiles()  %>% addPolylines(data=Sldf,col="red",popup= ~paste("SegmentID:",SegmentID, "<br>",
                                                                             "OptimalSpeedKPH: ",OptimalSpeedKPH)) %>% 
  #addPolylines(data=nwb_select,popup=~paste("WVK_ID: ",WVK_ID)) %>% 
  addPolylines(data=osm_ways,popup=~paste("ID: ",id),col="green",dashArray = T)



#laad shapefile
library(rgdal)
osm_shape<- readOGR("db/netherlands-latest-free.shp/gis.osm_roads_free_1.shp")
