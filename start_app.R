library(shiny)
library(leaflet)
library(sp)
load("db/basemap_select_wgs.RData")
load("db/nwb_select_wgs.RData")
#load("db/dist_matrix.RData")


##clip nwb 
xmin<- 4.65
xmax<- 4.67
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
nwb_select_wgs_2<- nwb_select_wgs[Ps1,]
basemap_select_wgs_2<- basemap_select_wgs[Ps1,]
save(nwb_select_wgs_2,file ="nwb_app/nwb_select_wgs.RData")
#save(basemap_select_wgs_2,file ="nwb_app/basemap_select_wgs.RData")

runApp("nwb_fcd_demo")

install.packages('rsconnect')
rsconnect::setAccountInfo(name='koolem',
                          token='493B4E9CD43658CF669D60EE68F1A169',
                          secret='1HBOjetNuwP6yAOuc2aazgdI+xVb3Pt1J3jH538F')
library(rsconnect)
rsconnect::deployApp('nwb_fcd_demo')

