#all libraries
source('lib.r')


#martijn code osm en nwb inlezen
#basemap<- fread("db/fcd-wetransfer/basemap_13347/segments-static.csv")
load("db/fcd_select.RData")
load("db/nwb_select2.RData")

#martijn code omzetten osm naar rdc
base_select<- Sldf
proj4string(base_select)<- "+proj=longlat +ellps=WGS84 +datum=WGS84 +towgs84=0,0,0"
rd<- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.999908 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +no_defs"

nwb_select<- spTransform(nwb_select,rd)
base_select<- spTransform(base_select,rd)


#converteer de shape naar een shape met om de lengte een punt
source('prepare_shape.r')
lengte = 10

#voor nwb en osm maak equidistant
x = pblapply( c(1:length(nwb_select@lines)), function(i){
  spacing(pad = nwb_select@lines[[i]]@Lines[[1]]@coords  ,lengte= lengte)
})


#twee euquidistante shapes


#vervang oude lijst in shape voor nieuwe lijst
nwb_select_split<- nwb_select
nwb_select_split@lines<- x

#tabel met index en minimale hausdorfdistance
source('half_hausdorf.r')
#OSM = shape
#NWB = shape

distance_lijst = pblapply(c(1:length(OSM@lines)), function(i){
  
  hausdorf_distances_to_NWB_lines =   lapply(c(1:length(NWB@lines)),function(j){
    half_hausdorf(OSM@lines[[i]]@Lines[[1]]@coords, NWB@lines[[j]]@Lines[[1]]@coords  )
  })
  
  
  minimum_distance = min(unlist( hausdorf_distances_to_NWB_lines))
  label = which( unlist(hausdorf_distances_to_NWB_lines) == minimum_distance)
  
  return(c(label, minimum_distance))
})


distance_matrix = do.call(rbind, distance_lijst)
distance_matrix = cbind(1:nrow(distance_matrix), distance_matrix)

colnames(distance_matrix) = c('index_OSM', 'index_NWB', 'Half_Hausdorfdistance')

distance_matrix[,1] = OSM@data$Segment_ID[distance_matrix[,1]]
distance_matrix[,2] = NWB@data$WVK_ID[distance_matrix[,1]]




#generic function to turn a shape into a shape file with equally distance points
source('prepare_shape.r')

#function to make a neigrest neighbour table from two point files

#A function to match lines in two shape files with help of the neighrest neighbour table of the points that where added to the lines in step 1


#koppel juncties uit OSM en NWB
source('vind_juncties.r')

juncties_OSM =vind_juncties(OSM)
juncties_NWB = vind_juncties(NWB)


min_dist_index = lapply(c(1:nrow(juncties_OSM)), function(i){
  which(  rdist(juncties_OSM[i,], juncties_NWB) ==     min(rdist(juncties_OSM[i,], juncties_NWB) ))
  
})

min_dist_index = unlist(min_dist_index)

gekoppelde_juncties = cbind(juncties_OSM, juncties_NWB[min_dist_index,])


colnames(gekoppelde_juncties) = c('x1', 'y1', 'x2', 'y2')


