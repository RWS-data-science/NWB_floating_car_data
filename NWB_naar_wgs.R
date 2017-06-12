library(rgdal)
library(sp)
library(tmap)
library(sf)
library(pbapply)
library(rPython)



python.load("omrekenen.py")

shape = readRDS('db/shape.rds')



shape@lines =  pblapply(coordinates(shape), function(x){
 

  
  x = lapply(x, function(z){

  
  z = apply(z, c(1), function(y){
    python.assign( 'coords', y)
    python.exec('wgsCoords = conv.fromRdToWgs( coords )')
   return(python.get('wgsCoords')) 
  })
  
    return(t(z))
    
  })
  
  return(x)
})



  
  saveRDS(shape, file = 'db/shape_wgs.rds')