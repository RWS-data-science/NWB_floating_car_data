shape = basemap_select@lines[1:100]


shape = nwb_select@lines[1:100]

totaal = lapply(1:length(shape), function(i){
  
 as.data.frame(shape[[i]]@Lines[[1]]@coords)
})

totaal = rbindlist(totaal)

totaal$coor = paste0(totaal$V1, '_', totaal$V2)

View(table(totaal$coor))

107809.601726209_446036.925749525


totaal = lapply(1:length(shape), function(i){
  
 if( any( abs( shape[[i]]@Lines[[1]]@coords[,1] - 107809.601726209) < 1e-2  ) ){
   return( as.data.frame(shape[[i]]@Lines[[1]]@coords))
 }
})

totaal = Filter(Negate(is.null), totaal)




totaal = lapply(1:length(OSM_no_doubles), function(i){
  
  if( any( abs( OSM_no_doubles[[i]][,1] - 107809.601726209) < 1e-2  ) ){
    return( as.data.frame( OSM_no_doubles[[i]] ))
  }
})

totaal = Filter(Negate(is.null), totaal)
