shape = basemap_select@lines[1:10]


shape = nwb_select@lines[1:100]

totaal = lapply(1:length(shape), function(i){
  
 as.data.frame(shape[[i]]@Lines[[1]]@coords)
})

totaal = rbindlist(totaal)

totaal$coor = paste0(totaal$V1, '_', totaal$V2)

View(table(totaal$coor))

106694.481077028   448203.227437655


totaal = lapply(1:length(shape), function(i){
  
 if( any( abs( shape[[i]]@Lines[[1]]@coords[,1] - 106694.481077028) < 1e-2  ) ){
   return( as.data.frame(shape[[i]]@Lines[[1]]@coords))
 }
})

totaal = Filter(Negate(is.null), totaal)
