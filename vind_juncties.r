

vind_juncties = function(shape){
  
  
  
  rand = data.frame()
  midden = data.frame()
  
  
  for(i in 1:length(shape@lines)){
  
    
    nieuw = shape@lines[[i]]@Lines[[1]]@coords
  
      midden_nieuw = nieuw[-c(1,nrow(nieuw )),]
      
    
    rand_nieuw = rbind(nieuw[1,] ,nieuw[nrow(nieuw),])
    
    rand = rbind(rand, rand_nieuw)
    midden = rbind(midden, midden_nieuw)
    
  
  }
  
  #neem alle punten mee die meer dan tweemaal voorkomen aan de rand
  juncties1 = rand[count(rand)$freq>2,]
  
  #neem alle punten mee die zowel aan de rand al in het midden van een segment voorkomen
  
  rand = rand[!duplicated(rand),]
  
  juncties2 = rbind(rand, midden)
  juncties2 = juncties2[duplicated(juncties2),]
  
  
  juncties = rbind(juncties1, juncties2)
 
  
  
  
  
  return(juncties) 
}