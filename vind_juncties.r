

vind_juncties = function(shape){
  
  points = data.frame()
  
  for(i in 1:length(shape@lines)){
  
    
    points = rbind(points,shape@lines[[i]]@Lines[[1]]@coords)
  
  
  }
  
  
  juncties = (points[duplicated(points),])
  juncties = juncties[!duplicated(juncties) ,]
 
  return(juncties) 
}