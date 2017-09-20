
#loop door alle lijnen

#als twee opeenvolgende punten hetzelfde zijn als twee opeenvolgende punten in een line die al is opgenomen moet de line daar gesplit worden

#alle lines bestaande uit 1 punt moeten geschrapt worden

NWB = nwb_select

#initialiseer de lijst van opgenomen lijnen
NWB_no_doubles = list(NWB@lines[[1]]@Lines[[1]]@coords)


#loop door de lines van het NWB en bekijk iedere lijn als kandidaat
for( i in 2:length(NWB@lines)){
  
  split = data.frame('split' = rep(-1, length(NWB@lines[[i]]@Lines[[1]]@coords)  ) )
  split$split[1] = 0
  n=0
  
  
  #loop door de punten van de kandidaat lijn
  for(j in 2:nrow(NWB@lines[[i]]@Lines[[1]]@coords)){
    
    #loop door alle opgenomen lijnen
    for( k in 1:length(NWB_no_doubles)){
      
      #verschil van de punten op de k-de opgenomen lijn met het j-de en j-1-de punt van de kandidaat lijn 
      
    
      
      
      if( (NWB_no_doubles[[k]][-1,] - NWB@lines[[i]]@Lines[[1]]@coords[j,]) == 0 & (NWB_no_doubles[[k]][-nrow(NWB_no_doubles[[k]]),] - NWB@lines[[i]]@Lines[[1]]@coords[j-1,]) ==0){
        #als afstand tussen twee opeenvolgende punten 0 is dan 
        n = n+1
        
      }
      
    
      }#einde opgenomen lijnen loop
    
    
    split$split[j] = n
    
  }#einde punten van kandidaat loop
  
  #split het dataframe op alle punten dat
 extra =  split( as.data.frame(NWB@lines[[i]]@Lines[[1]]@coords), split$split )

#voeg deze toe aan NWB_no_doubles  
NWB_no_doubles = c(NWB_no_doubles, extra )
  
}#einde kandidaten loop



