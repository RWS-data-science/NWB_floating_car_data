

vind_juncties = function(shape){
  
  
  #vind midden
  
  midden = lapply( 1:length(shape@lines), function(i){
    
    nieuw = data.frame( 'x' = shape@lines[[i]]@Lines[[1]]@coords[,1], 'y' = shape@lines[[i]]@Lines[[1]]@coords[,2], 'ID' = shape@lines[[i]]@ID )
    
    nieuw = nieuw[-c(1,nrow(nieuw )),]
    
    if(nrow(nieuw) > 0){
      return(nieuw)
    }else{
      return(NULL)
    }
    
  })
  
 midden =  Filter(Negate(is.null), midden)
  midden = rbindlist(midden)
  
  
  
  
  
  
  #vind rand
  
  rand = lapply( 1:length(shape@lines), function(i){
    
     data.frame( 'x' = c( shape@lines[[i]]@Lines[[1]]@coords[1,1] ,   shape@lines[[i]]@Lines[[1]]@coords[nrow(shape@lines[[i]]@Lines[[1]]@coords),1]   )        , 'y' =  c( shape@lines[[i]]@Lines[[1]]@coords[1,2] ,   shape@lines[[i]]@Lines[[1]]@coords[nrow(shape@lines[[i]]@Lines[[1]]@coords),2 ]   ) , 'ID' = shape@lines[[i]]@ID )
    
    
  })
  
  
  rand = rbindlist(rand)
  
  
  
  
  
  
  #neem alle punten mee die meer dan tweemaal voorkomen aan de rand
  
  rand$key = paste(rand$x, rand$y)
  
  aantalkeer = as.data.frame(table(rand$key))
  colnames(aantalkeer) = c('key', 'freq')
rand = merge(x = rand, y = aantalkeer, all.x = TRUE, all.y = TRUE , by = 'key')
rand$key = NULL
  rand = as.data.frame(rand)
    
  juncties1 =  rand[rand$freq > 2, -4]
  
  rand$freq = NULL
  juncties2 = rbind(rand, midden)
  juncties2 = juncties2[duplicated(juncties2),]
  
  
  juncties = rbind(juncties1, juncties2)
  
  juncties = juncties[!duplicated(juncties), ]
 
  juncties = as.data.frame(juncties)
  
  
  
  return(juncties) 
}