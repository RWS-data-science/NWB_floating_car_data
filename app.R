#all libraries
source('lib.r')


#martijn code osm en nwb inlezen

#martijn code omzetten osm naar rdc

#convert shape to wgs
filename = 'db/shape/Wegvakken.shx'
shape = readOGR(filename)

#source('omrekenen.r')
#shape = omrekenen(shape)

#converteer de shape naar een shape met om de lengte een punt
source('prepare_shape.r')
lengte = 10

#voor nwb en osm maak equidistant
shape@lines = pblapply( c(1:length(shape@lines)), function(i){
  spacing(pad = shape@lines[[i]]@Lines[[1]]@coords  ,lengte= lengte)
})


#twee euquidistante shapes


#vervang oude lijst in shape voor nieuwe lijst

#neirest neigbourtabel

#stemmen





#generic function to turn a shape into a shape file with equally distance points
source('prepare_shape.r')

#function to make a neigrest neighbour table from two point files

#A function to match lines in two shape files with help of the neighrest neighbour table of the points that where added to the lines in step 1




