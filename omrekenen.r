
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




for(i in 1:length(shape@lines)){
  coords = shape@lines[[i]]@Lines[[1]]@coords
  
  for(j in 1:nrow(coords)){
    
    python.assign('wgsCoords', coords[j,])
    python.exec('wgsCoords = conv.fromRdToWgs( coords )')
    coords[j,] = python.get('wgsCoords')
    
  }
  
  shape@lines[[i]]@Lines[[1]]@coords = coords
  
}
