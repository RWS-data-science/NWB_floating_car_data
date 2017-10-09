library(shiny)
library(leaflet)
library(sp)

load("db/nwb_select_features.RData")
load("db/basemap_select_features.RData")


wgs<- "+proj=longlat +ellps=WGS84 +datum=WGS84 +towgs84=0,0,0"

basemap_select_wgs<- spTransform(basemap_select,wgs)
nwb_select_wgs<- spTransform(nwb_select,wgs)

nwb_select_wgs$dekking_dag_scale<- 0.2+(nwb_select_wgs$dekking_dag*0.8)/(1-0.2) #scale between 0.2 and 1


runApp("nwb_fcd_demo")

