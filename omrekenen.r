
omrekenen = function(shape){


python.load("omrekenen.py")

# python.assign( 'coords', c(91819, 437802))
# python.exec('wgsCoords = conv.fromRdToWgs( coords )')
# coords = python.get('wgsCoords')
# 
# 
# python.assign('wgsCoords', coords)
# python.exec('coords = conv.fromWgsToRd( wgsCoords )')
# python.get('coords')
# 
# 




omgerekende_shape = lapply( c(1:length(shape@lines)), function(i){
  coords = shape@lines[[i]]@Lines[[1]]@coords
  
  lapply( c(1:nrow(coords)), function(j){
    
    
    python.assign('wgsCoords', coords[j,])
    python.exec('coords = conv.fromWgsToRd( wgsCoords )')
    coords[j,] = python.get('coords')
    coords[j,]
  })
  
  return(coords)
  
})

return(omgerekende_shape)
}