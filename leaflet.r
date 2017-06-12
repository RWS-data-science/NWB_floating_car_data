library(rgdal)
library(sp)
library(tmap)
library(sf)
library(leaflet)

shape = readRDS('db/shape_wgs.rds')


for(i in 1:nrow(shape@data)){

coor = shape@lines[[i]][[1]]

x = coor[,1]
y = coor[,2]
coor[,1] = y
coor[,2] = x

map = leaflet(coor) 
map = addTiles(map)

map =   addPolylines(map)
print(map)
browser()
}