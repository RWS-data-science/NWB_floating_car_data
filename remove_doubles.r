


remove_doubles = function(OSM){


OSM_no_doubles = list(OSM@lines[[1]]@Lines[[1]]@coords)
IDs =  as.numeric(as.character( OSM@data$segmentID[1]  ) ) 
IDs_twee_richting = c()




for(i in 2:length(OSM@lines)){
  
  x = OSM@lines[[i]]@Lines[[1]]@coords[ nrow(OSM@lines[[i]]@Lines[[1]]@coords):1 ,]
  
  
  
  dubbel = lapply(1:length(OSM_no_doubles), function(j){
    if(nrow(OSM_no_doubles[[j]])== nrow(x)){
      if(sum(OSM_no_doubles[[j]] == x) == ncol(x)*nrow(x) ){
        return(IDs[j])
      }else{
        return(0)
      }
    }else{
      return(0)
    }
  })
  
  dubbel = unlist(dubbel)
  
  if(sum( dubbel)== 0){
  OSM_no_doubles =  c(OSM_no_doubles, list(OSM@lines[[i]]@Lines[[1]]@coords))
  IDs = c(IDs, as.numeric(as.character( OSM@data$segmentID[i] )) )
  }else{
    IDs_twee_richting = c(IDs_twee_richting, sum(dubbel))
  }
   
    
    
  
  
}

output = list(IDs, IDs_twee_richting)


return(output)
}












# 
# #loop door alle lijnen
# 
# #als twee opeenvolgende punten hetzelfde zijn als twee opeenvolgende punten in een line die al is opgenomen moet de line daar gesplit worden
# 
# #alle lines bestaande uit 1 punt moeten geschrapt worden
# 
# NWB = basemap_select
# NWB@lines = NWB@lines[1:100]
# #initialiseer de lijst van opgenomen lijnen
# NWB_no_doubles = list(NWB@lines[[1]]@Lines[[1]]@coords)
# 
# 
# #loop door de lines van het NWB en bekijk iedere lijn als kandidaat
# for( i in 2:length(NWB@lines)){
#   
#   print(i/ length(NWB@lines))
#   
#   NWB@lines[[i]]@Lines[[1]]@coords = NWB@lines[[i]]@Lines[[1]]@coords[nrow(NWB@lines[[i]]@Lines[[1]]@coords):1,]
#   
#   split = data.frame('split' = rep(0, nrow(NWB@lines[[i]]@Lines[[1]]@coords)  ) )
#   n=0
#   
#   
#   
#   #loop door de punten van de kandidaat lijn
#   for(j in 2:nrow(NWB@lines[[i]]@Lines[[1]]@coords)){
#     
#     #loop door alle opgenomen lijnen
#     for( k in 1:length(NWB_no_doubles)){
#       
#       #verschil van de punten op de k-de opgenomen lijn met het j-de en j-1-de punt van de kandidaat lijn 
#       
#     
#       
#       
#       if( any(   abs(  rowSums( as.data.frame(NWB_no_doubles[[k]][-1,] - NWB@lines[[i]]@Lines[[1]]@coords[j,] ) )  ) < 1e-1 &   abs(  rowSums(  as.data.frame( (NWB_no_doubles[[k]][-nrow(NWB_no_doubles[[k]]),] - NWB@lines[[i]]@Lines[[1]]@coords[j-1,]) ) ) ) < 1e-1 )){
#         #als afstand tussen twee opeenvolgende punten 0 is dan 
#         n = n+1
#         
#       }
#       
#     
#       }#einde opgenomen lijnen loop
#     
#     
#     split$split[j] = n
#     
#   }#einde punten van kandidaat loop
#   
#   #split het dataframe op alle punten dat
#  extra =  split( as.data.frame(NWB@lines[[i]]@Lines[[1]]@coords), split$split )
# 
#  #verwijder lijnen die uit maar 1 coordinaat bestaan
#  extra = lapply(c(1:length(extra)), function(l){
#    if(nrow(extra[[l]])>1){
#      return(extra[[l]])
#    }
#  })
#  extra = Filter(Negate(is.null), extra)
#  
# #voeg deze toe aan NWB_no_doubles  
# NWB_no_doubles = c(NWB_no_doubles, extra )
#   
# 
# 
# }#einde kandidaten loop
# 
# 
# any(   abs(  rowSums( as.data.frame(x[[k]][-1,] - totaal[[i]][j,] ) )  ) < 1e-1 &   abs(  rowSums(  as.data.frame( (x[[4]][-nrow(x[[k]]),] - totaal[[i]][j-1,]) ) ) ) < 1e-1 )
