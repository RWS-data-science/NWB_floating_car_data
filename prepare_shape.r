
filename = 'db/shape/Wegvakken.shx'
shape = readOGR(filename)

lines = shape@lines
data = shape@data

lines = lines[1:10000]
data = data[1:10000,]
lines[[1]]@lines





for(i in 1:length(shape@lines)){
  coords = shape@lines[[i]]@Lines[[1]]@coords
  
  print(coords)
}

