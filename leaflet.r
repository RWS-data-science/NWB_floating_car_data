library(rgdal)
library(sp)
library(tmap)
library(sf)
library(leaflet)

shape <- readOGR("db/shape", 'Wegvakken')




map = leaflet(shape[1,]) 
map = addTiles(map)

map =   addPolylines(map)