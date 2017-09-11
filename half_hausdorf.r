# filename = 'db/shape/Wegvakken.shx'
# shape = readOGR(filename)
# 
# 
# 
# 
# 
# 
# #test voor 1 line
# lines = shape@lines
# lines= lines[1:1000]
# pad1 = lines[[256]]@Lines[[1]]@coords
# pad2 = lines[[257]]@Lines[[1]]@coords

#half_hausdorf(pad1,pad2)

half_hausdorf = function(pad_OSM, pad_NWB){
dis = rdist(pad_OSM, pad_NWB)

return(max(apply( dis , c(1), min)))
}




mean_dist = function(pad_OSM, pad_NWB){
  dis = rdist(pad_OSM, pad_NWB)
  
  return(mean(apply( dis , c(1), min)))
}
