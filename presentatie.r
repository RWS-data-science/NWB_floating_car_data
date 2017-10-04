source('lib.r')

#laad in en laat zien
load("db/basemap_select_features.RData")
load("db/nwb_select_features.RData")

View(nwb_select)


#transformeer naar wgs
wgs<- "+proj=longlat +ellps=WGS84 +datum=WGS84 +towgs84=0,0,0"
nwb_select<- spTransform(nwb_select,wgs)
basemap_select<- spTransform(basemap_select,wgs)


#plot nwb
m = leaflet()
m = addProviderTiles(m, providers$CartoDB)
for( i in 1:length(nwb_select)){
  
  
  
  m=   addPolylines( m, lat = nwb_select@lines[[i]]@Lines[[1]]@coords[,2], lng =  nwb_select@lines[[i]]@Lines[[1]]@coords[,1], color = 'blue',  popup = paste( '<h> id:', nwb_select$WVK_ID[i], 'maxdist', nwb_select$max_afstand_osm[i] ,'vorm', nwb_select$afwijkende_vorm[i]  ,   '</h>'  ))

  
  }



#plot osm
for( i in 1:length(basemap_select)){
  m=   addPolylines( m, lat = basemap_select@lines[[i]]@Lines[[1]]@coords[,2], lng =  basemap_select@lines[[i]]@Lines[[1]]@coords[,1], color = 'red' )
}

print(m)

#junctie feature

#bereken
juncties = readRDS('db/juncties.rds')

m = leaflet()
m = addProviderTiles(m,providers$CartoDB)
m = addCircleMarkers(m, lat = juncties$lat_nwb , lng = juncties$lon_nwb, color ='blue', popup = paste( '<h> dist:', juncties$dist , 'id:', juncties$id , '</h>' ) )
m = addCircleMarkers(m, lat = juncties$lat_osm , lng = juncties$lon_osm, color ='red', popup = paste( '<h> dist:', juncties$dist , 'id:', juncties$id , '</h>' ) )

print(m)



#alle plekken waar max gereden snelheid snachts meer dan 10kmh afwijkt

#meer dan 15kmh verschil
m = leaflet()
m = addProviderTiles(m, providers$CartoDB)
for( i in 1:length(nwb_select)){
  if(!is.na(nwb_select@data$vmax_OSM[i]) & ! is.na(nwb_select@data$v_mean_nacht[i])  ){
  if( abs(   as.numeric(as.character(nwb_select@data$vmax_OSM[i])) -  as.numeric(as.character(nwb_select@data$v_mean_nacht[i]))) > 15 ){
  m=   addPolylines( m, lat = nwb_select@lines[[i]]@Lines[[1]]@coords[,2], lng =  nwb_select@lines[[i]]@Lines[[1]]@coords[,1], color = 'red',  popup = paste( '<h> vmax_OSM:',nwb_select@data$vmax_OSM[i], 'vmean_nacht:',  nwb_select@data$v_mean_nacht[i] , '</h>') )
  }
  }
  }
print(m)


#vmean hoger dan vmax
m = leaflet()
m = addProviderTiles(m, providers$CartoDB)
for( i in 1:length(nwb_select)){
  if(!is.na(nwb_select@data$vmax_OSM[i]) & ! is.na(nwb_select@data$v_mean_dag[i])  ){
    if(   as.numeric(as.character(nwb_select@data$vmax_OSM[i])) -  as.numeric(as.character(nwb_select@data$v_mean_dag[i]))   < 0 ){
      m=   addPolylines( m, lat = nwb_select@lines[[i]]@Lines[[1]]@coords[,2], lng =  nwb_select@lines[[i]]@Lines[[1]]@coords[,1], color = 'red',  popup = paste( '<h> vmax_OSM:',nwb_select@data$vmax_OSM[i], 'vmean_dag:',  nwb_select@data$v_mean_dag[i] , '</h>') )
    }
  }
}
print(m)



# vmax is 50 vmean minder dan 35
m = leaflet()
m = addProviderTiles(m, providers$CartoDB)
for( i in 1:length(nwb_select)){
  if(!is.na(nwb_select@data$vmax_OSM[i]) & ! is.na(nwb_select@data$v_mean_nacht[i])  ){
    if(   as.numeric(as.character(nwb_select@data$vmax_OSM[i])) == 50 &   as.numeric(as.character(nwb_select@data$v_mean_nacht[i]))   < 36 ){
      m=   addPolylines( m, lat = nwb_select@lines[[i]]@Lines[[1]]@coords[,2], lng =  nwb_select@lines[[i]]@Lines[[1]]@coords[,1], color = 'red',  popup = paste( '<h> vmax_OSM:',nwb_select@data$vmax_OSM[i], 'vmean_nacht:',  nwb_select@data$v_mean_nacht[i] , '</h>') )
    }
  }
}
print(m)


# vmax is 50 vmean minder dan 35 dekking >0.5
m = leaflet()
m = addProviderTiles(m, providers$CartoDB)
for( i in 1:length(nwb_select)){
  if(!is.na(nwb_select@data$vmax[i]) & ! is.na(nwb_select@data$v_mean_nacht[i]) & !is.na(nwb_select@data$dekking_dag[i])  ){
    if(   as.numeric(as.character(nwb_select@data$vmax[i])) == 50 &   as.numeric(as.character(nwb_select@data$v_mean_nacht[i]))   < 36 & nwb_select@data$dekking_dag[i] > 0.5 ){
      m=   addPolylines( m, lat = nwb_select@lines[[i]]@Lines[[1]]@coords[,2], lng =  nwb_select@lines[[i]]@Lines[[1]]@coords[,1], color = 'red',  popup = paste( '<h> vmax_OSM:',nwb_select@data$vmax_OSM[i], 'vmean_nacht:',  nwb_select@data$v_mean_nacht[i] , '</h>') )
    }
  }
}
print(m)







#vmean groot vmedian ongeveer even groot
m = leaflet()
m = addProviderTiles(m, providers$CartoDB)
for( i in 1:length(nwb_select)){
  if(!is.na(nwb_select@data$mean_afstand_osm[i])){
    if(   as.numeric(as.character(nwb_select@data$mean_afstand_osm[i])) > 338  ){
      m=   addPolylines( m, lat = nwb_select@lines[[i]]@Lines[[1]]@coords[,2], lng =  nwb_select@lines[[i]]@Lines[[1]]@coords[,1], color = 'red',  popup = paste( '<h> dist:',nwb_select@data$mean_afstand_osm[i], '</h>') )
    }
  }
}
print(m)







