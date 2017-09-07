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

#neirest neigbourtabel

#stemmen





#generic function to turn a shape into a shape file with equally distance points
source('prepare_shape.r')

#function to make a neigrest neighbour table from two point files

#A function to match lines in two shape files with help of the neighrest neighbour table of the points that where added to the lines in step 1




