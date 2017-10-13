

maak_shapefiles <- function(nwb_deel,osm_deel){
 
   rd<- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.999908 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +no_defs"
  
  nwb_select<- spTransform(nwb_deel,rd)
  basemap_select<- spTransform(osm_deel,rd)
  
  ##verwijder fiets- en voetpaden uit NWB
  nwb_select <- nwb_select[which(!nwb_select$BST_CODE %in% c("VP","FP")),]
  
  rm(rd)

  
  ##Haal dubbele OSM lijnstukken weg
  source('remove_doubles.r')
  #maak een vector van IDs die de shape omscrijven terwijl alles maar 1 keer voorkomt
  output = remove_doubles(basemap_select) 
  IDs = output[[1]]
  IDs_twee_richting = output[[2]]
  
  #gooi alle lines die niet in de lijst van IDs voorkomen weg
  
  basemap_select<- basemap_select[( as.numeric( as.character(basemap_select@data$segmentID)) %in% IDs),]
  
  #voeg kolom toe of basemap tweerichting is
  basemap_select$twee_richting <- ifelse(basemap_select$segmentID %in% IDs_twee_richting,1,0)
  
  
  rm(IDs_twee_richting)
  rm(IDs)
  rm(output)

  
  
  ##Equidistant
 
  source('prepare_shape.r')
  lengte = 25
  
  #Maak NWB equidistant
  nwb_select_eq<- nwb_select
  x = lapply( c(1:length(nwb_select@lines)), function(i){
    as.data.frame(spacing(pad = nwb_select_eq@lines[[i]]@Lines[[1]]@coords  ,lengte= lengte))
  })
  
  
  for(i in 1:length(nwb_select@lines)){
    colnames(x[[i]]) = c('x','y')
    nwb_select_eq@lines[[i]]@Lines[[1]]@coords = as.matrix(x[[i]])
  }
  
  
  
  #Maak OSM equidistant
  basemap_select_eq<- basemap_select
  x = lapply( c(1:length(basemap_select@lines)), function(i){
    spacing(pad = basemap_select_eq@lines[[i]]@Lines[[1]]@coords  ,lengte= lengte)
  })
  
  for(i in 1:length(basemap_select_eq@lines)){
    colnames(x[[i]]) = c('x','y')
    basemap_select_eq@lines[[i]]@Lines[[1]]@coords = as.matrix(x[[i]])
  }
  rm(lengte)
  rm(x)
  rm(i)

  
  #################################################EIND PREPROCESSING#############################################
  
  #####################################################FEATURE ENGENEERING######################################################
  
  
  
  
  
  ##MATCHING OSM segmenten aan NWB segmenten
  
  
 
  basemap_select_eq$segmentID<- as.integer(as.character(basemap_select_eq$segmentID))
  source('half_hausdorf.r')
  
  distance_lijst_OSM = lapply(c(1:length(basemap_select_eq@lines)), function(i){
    
    hausdorf_distances_to_NWB_lines =   lapply(c(1:length(nwb_select_eq@lines)),function(j){
      mean_dist(basemap_select_eq@lines[[i]]@Lines[[1]]@coords, nwb_select_eq@lines[[j]]@Lines[[1]]@coords  )
    })
    
    angle_to_NWB_lines = lapply(c(1:length(nwb_select_eq@lines)),function(j){
      ba_x= basemap_select_eq@lines[[i]]@Lines[[1]]@coords[1,1] 
      ba_y= basemap_select_eq@lines[[i]]@Lines[[1]]@coords[1,2] 
      bb_x= basemap_select_eq@lines[[i]]@Lines[[1]]@coords[nrow(basemap_select_eq@lines[[i]]@Lines[[1]]@coords),1] 
      bb_y= basemap_select_eq@lines[[i]]@Lines[[1]]@coords[nrow(basemap_select_eq@lines[[i]]@Lines[[1]]@coords),2] 
      a1<- atan2(bb_y-ba_y,bb_x-ba_x)
      
      # na_min_x<- min(abs(outer(nwb_select_eq@lines[[j]]@Lines[[1]]@coords[,1],basemap_select_eq@lines[[i]]@Lines[[1]]@coords[,1],FUN="-")))
      # na_x=  nwb_select_eq@lines[[j]]@Lines[[1]]@coords[which(abs(outer(nwb_select_eq@lines[[j]]@Lines[[1]]@coords[,1],basemap_select_eq@lines[[i]]@Lines[[1]]@coords[,1],FUN="-"))==na_min_x,arr.ind = TRUE)[1,1],1]
      # na_y=  nwb_select_eq@lines[[j]]@Lines[[1]]@coords[which(abs(outer(nwb_select_eq@lines[[j]]@Lines[[1]]@coords[,1],basemap_select_eq@lines[[i]]@Lines[[1]]@coords[,1],FUN="-"))==na_min_x,arr.ind = TRUE)[1,1],2]
      # 
      # na_min_y<- min(abs(outer(nwb_select_eq@lines[[j]]@Lines[[1]]@coords[,2],basemap_select_eq@lines[[i]]@Lines[[1]]@coords[,2],FUN="-")))
      # nb_x=  nwb_select_eq@lines[[j]]@Lines[[1]]@coords[which(abs(outer(nwb_select_eq@lines[[j]]@Lines[[1]]@coords[,2],basemap_select_eq@lines[[i]]@Lines[[1]]@coords[,2],FUN="-"))==na_min_y,arr.ind = TRUE)[1,1],1]
      # nb_y=  nwb_select_eq@lines[[j]]@Lines[[1]]@coords[which(abs(outer(nwb_select_eq@lines[[j]]@Lines[[1]]@coords[,2],basemap_select_eq@lines[[i]]@Lines[[1]]@coords[,2],FUN="-"))==na_min_y,arr.ind = TRUE)[1,1],2]
      na_x= nwb_select_eq@lines[[j]]@Lines[[1]]@coords[1,1] 
      na_y= nwb_select_eq@lines[[j]]@Lines[[1]]@coords[1,2] 
      nb_x= nwb_select_eq@lines[[j]]@Lines[[1]]@coords[nrow(nwb_select_eq@lines[[j]]@Lines[[1]]@coords),1] 
      nb_y= nwb_select_eq@lines[[j]]@Lines[[1]]@coords[nrow(nwb_select_eq@lines[[j]]@Lines[[1]]@coords),2] 
      
      a2<- atan2(nb_y-na_y,nb_x-na_x)
      angle<- (a1-a2)*180/pi
      return(angle)
    })
    
    minimum_distance_osm = min(unlist( hausdorf_distances_to_NWB_lines))
    
    label = which.min( unlist(hausdorf_distances_to_NWB_lines) )
    angle = angle_to_NWB_lines[[label]] 
    
    return( data.frame( 'OSM_ID'=  as.integer(basemap_select_eq$segmentID[i]), 'WVK_ID'=  as.integer(as.numeric(as.character(nwb_select_eq$WVK_ID[label]))), 'dist' = minimum_distance_osm,'angle_to_nn' = as.integer(angle)))
  })
  
  
  
  distance_lijst_OSM = rbindlist(distance_lijst_OSM)
  
  basemap_select@data$'afstand_nwb_lijn' <- distance_lijst_OSM$dist[match(basemap_select@data$segmentID , distance_lijst_OSM$OSM_ID)]
  basemap_select@data$'nearest_nwb_line_id' <- distance_lijst_OSM$WVK_ID[match(basemap_select@data$segmentID , distance_lijst_OSM$OSM_ID)]
  
  nwb_select$is_nn50<- ifelse(nwb_select$WVK_ID %in% basemap_select$nearest_nwb_line_id[basemap_select$afstand_nwb_lijn<50],TRUE,FALSE )
  nwb_select$nn_OSM<- distance_lijst_OSM$OSM_ID[match(nwb_select$WVK_ID,distance_lijst_OSM$WVK_ID)]
  nwb_select$nn_distance<- distance_lijst_OSM$Half_Hausdorfdistance[match(nwb_select$WVK_ID,distance_lijst_OSM$WVK_ID)]
  nwb_select$nn_angle<- distance_lijst_OSM$angle_to_nn[match(nwb_select$WVK_ID,distance_lijst_OSM$WVK_ID)]
  
  
  
  
  #Bewaar de nn alleen als de hoek tussen de twee gematchte segmenten <= 30 graden. Dit voorkomt dat kruisende wegen ten onrechte worden gematched.
  nwb_select$nn_OSM_geen_kruispunt<- ifelse(abs(nwb_select$nn_angle)<=30 | abs(abs(nwb_select$nn_angle)-180)<=30, nwb_select$nn_OSM, NA  )
  
  
  rm(distance_lijst_OSM)

  
  
  
  ##afstanden juncties NWB tot juncties OSM
  

  
  #VUL HIER NIET DE EQUIDISTANTE SHAPE IN MAAR DE ORGINELE SHAPES!
  source('vind_juncties.r')
  
  
  #vind coordinaten van juncties in het OSM en het NWB
  
  OSM_juncties = vind_juncties(basemap_select, osm = TRUE)
  NWB_juncties = vind_juncties(nwb_select, osm = FALSE)
  
  
  
  
  #vind voor iedere NWB junctie de dichtsbijzijnde OSM junctie
  dichtst_bijzijnde_OSM_junctie =  pblapply(c(1:nrow(NWB_juncties)), function(i){
    dist =  sqrt ( (OSM_juncties[,1] - as.numeric(NWB_juncties[i,1])   )^2   +   (OSM_juncties[,2] - as.numeric(NWB_juncties[i,2])  )^2 )
    buren = OSM_juncties[dist == min(dist),]
    x = data.frame( 'x_osm' =  buren[1,1], 'y_osm' =  buren[1,2], 'id_osm' = buren[1,3], 'dist_osm' = min(dist))
    
    return(x)
    
  })
  
  #zet in een dataframe
  dichtst_bijzijnde_OSM_junctie =  rbindlist(dichtst_bijzijnde_OSM_junctie)
  juncties = cbind(NWB_juncties, dichtst_bijzijnde_OSM_junctie  )
  colnames(juncties) = c('x_NWB', 'y_NWB', 'WVK_ID', 'x_osm', 'y_osm', 'id_osm', 'dist')
  
  matrix_juncties = juncties
  rm(juncties)
  rm(dichtst_bijzijnde_OSM_junctie)
  rm(NWB_juncties)
  rm(OSM_juncties)
  
  nwb_select@data$'afstand_osm_splitsing' <- matrix_juncties$dist[match(nwb_select@data$WVK_ID , matrix_juncties$WVK_ID)]
  nwb_select@data$'x_osm_splitsing' <- matrix_juncties$x_osm[match(nwb_select@data$WVK_ID , matrix_juncties$WVK_ID)]
  nwb_select@data$'y_osm_splitsing' <- matrix_juncties$y_osm[match(nwb_select@data$WVK_ID , matrix_juncties$WVK_ID)]
  #rm(juncties)
  rm(matrix_juncties)

  ##Afwijking NWB lijn tot basemap shape

  #GEBRUIK NU WEL EQUIDISTANTE SHAPES
  
  #zet alle punten van OSM in een dataframe
  OSM = basemap_select_eq
  NWB = nwb_select_eq
  
  points_OSM = pblapply(c(1:length(OSM@lines)), function(i){
    as.data.frame(OSM@lines[[i]]@Lines[[1]]@coords)
  })
  points_OSM = rbindlist(points_OSM)
  points_OSM = points_OSM[!duplicated(points_OSM),]
  
  
  #loop door alle NWB lines heen en bereken de min, max en mean tot de points
  distance_matrix = pblapply(1:length(NWB@lines), function(i){
    
    distances = lapply(1:nrow(NWB@lines[[i]]@Lines[[1]]@coords ), function(j){
      min(sqrt(  ( (points_OSM$x - NWB@lines[[i]]@Lines[[1]]@coords[j,1])^2 + (points_OSM$y - NWB@lines[[i]]@Lines[[1]]@coords[j,2])^2) ) )
      
    })
    distances = unlist(distances)
    return( data.frame( 'WVK_ID' = as.numeric(as.character(NWB@data$WVK_ID[i])), 'max' =  max(distances), 'min' = min(distances) , 'mean' = mean(distances), 'median' =  median(distances)  ))
    
  })
  
  distance_matrix = rbindlist(distance_matrix)
  
  
  
  nwb_select@data$'max_afstand_osm' <- distance_matrix$max[match(nwb_select$WVK_ID,distance_matrix$WVK_ID)]
  nwb_select@data$'min_afstand_osm' <- distance_matrix$min[match(nwb_select$WVK_ID,distance_matrix$WVK_ID)]
  nwb_select@data$'mean_afstand_osm' <- distance_matrix$mean[match(nwb_select$WVK_ID,distance_matrix$WVK_ID)]
  nwb_select@data$'median_afstand_osm' <- distance_matrix$median[match(nwb_select$WVK_ID,distance_matrix$WVK_ID)]
  
  rm(distance_matrix)
  rm(OSM)
  rm(NWB)
  rm(points_OSM)
  
  
  ##Afwijking OSM lijn to NWB shape
  
  #GEBRUIK NU WEL EQUIDISTANTE SHAPES
  
  #zet alle punten van OSM in een dataframe
  OSM = basemap_select_eq
  NWB = nwb_select_eq
  
  points_nwb = pblapply(c(1:length(NWB@lines)), function(i){
    as.data.frame(NWB@lines[[i]]@Lines[[1]]@coords)
  })
  points_nwb = rbindlist(points_nwb)
  points_nwb = points_nwb[!duplicated(points_nwb),]
  
  
  #loop door alle OSM lines heen en bereken de min, max en mean tot de points
  distance_matrix = pblapply(1:length(OSM@lines), function(i){
    
    distances = lapply(1:nrow(OSM@lines[[i]]@Lines[[1]]@coords ), function(j){
      min(sqrt(  ( (points_nwb$x - OSM@lines[[i]]@Lines[[1]]@coords[j,1])^2 + (points_nwb$y - OSM@lines[[i]]@Lines[[1]]@coords[j,2])^2) ) )
      
    })
    distances = unlist(distances)
    return( data.frame( 'segmentID' = as.numeric(as.character(OSM@data$segmentID[i])), 'max' =  max(distances), 'min' = min(distances) , 'mean' = mean(distances), 'median' =  median(distances)  ))
    
  })
  
  distance_matrix = rbindlist(distance_matrix)
  
  
  
  basemap_select@data$'max_afstand_nwb' <- distance_matrix$max[match(basemap_select$segmentID,distance_matrix$segmentID)]
  basemap_select@data$'min_afstand_nwb' <- distance_matrix$min[match(basemap_select$segmentID,distance_matrix$segmentID)]
  basemap_select@data$'mean_afstand_nwb' <- distance_matrix$mean[match(basemap_select$segmentID,distance_matrix$segmentID)]
  basemap_select@data$'median_afstand_nwb' <- distance_matrix$median[match(basemap_select$segmentID,distance_matrix$segmentID)]
  
  rm(distance_matrix)
  rm(OSM)
  rm(NWB)
  rm(points_nwb)
  
  
  
  
  ########################################################EIND FEATURE ENGINEERING#################################################################
  
  
  
  ########################################FOUTEN OPSPOREN#################################
  
  ####hier alleen nwb_select en basemap_select gebruiken als input
  
  #######################################EIND FOUTEN OPSPOREN############################################
  
  
  
  
  
  ##Merge metadata
  
  
  
  
  nwb_select$vmax<- vmax_merged$OMSCHR[match(nwb_select$WVK_ID,vmax_merged$WVK_ID)]
  #nwb_select_wgs$vmax<- vmax_merged$OMSCHR[match(nwb_select_wgs$WVK_ID,vmax_merged$WVK_ID)]
  
  nwb_select$vmax_OSM <- basemap_select$maxSpeedKPH[match(nwb_select$nn_OSM_geen_kruispunt,basemap_select$segmentID)]
  nwb_select$vOpt_OSM <- basemap_select$optSpeedKPH[match(nwb_select$nn_OSM_geen_kruispunt,basemap_select$segmentID)]
  
  
  ##straatnamen
  nwb_select$straatnaam_OSM <- basemap_select$name[match(nwb_select$nn_OSM_geen_kruispunt,basemap_select$segmentID)]
  nwb_select$straatnaam_string_dist<- stringdist(tolower(nwb_select$STT_NAAM),tolower(nwb_select$straatnaam_OSM), method = "lv")
  
  
  #gemeente
  nwb_select$gemeente_check <- as.character(over(nwb_select,gemeenten)$gemeentena)
  
  nwb_select$gemeente_string_dist<- stringdist(tolower(nwb_select$GME_NAAM),tolower(nwb_select$gemeente_check), method = "lv")
  
  #rijrichting
  nwb_select$twee_richting_OSM <- basemap_select$twee_richting[match(nwb_select$nn_OSM_geen_kruispunt,basemap_select$segmentID)]
  
  #nwb_select$rijrichting_verschilt <- ifelse(nwb_select$RIJRICHTNG)
  
  rm(gemeenten)
  rm(vmax_weggeg)
  rm(vmax_wkd)
  rm(vmax_merged)
  
  
  nwb_select$v_mean_dag<- dag_agg$v_mean[match(nwb_select$nn_OSM_geen_kruispunt,dag_agg$SegmentID)]
  nwb_select$dekking_dag<- dag_agg$perc_coverage[match(nwb_select$nn_OSM_geen_kruispunt,dag_agg$SegmentID)]
  
  nwb_select$v_mean_nacht<- nacht_agg$v_mean[match(nwb_select$nn_OSM_geen_kruispunt,nacht_agg$SegmentID)]
  nwb_select$dekking_nacht<- nacht_agg$perc_coverage[match(nwb_select$nn_OSM_geen_kruispunt,nacht_agg$SegmentID)]
  
  nwb_select$v_diff_dag<- nwb_select$vmax - nwb_select$v_mean_dag
  nwb_select$v_diff_nacht<- nwb_select$vmax - nwb_select$v_mean_nacht
  
  
  
  basemap_select$dekking_dag <- dag_agg$perc_coverage[match(basemap_select$segmentID,dag_agg$SegmentID)]
  
  
  
  
  
  ##afwijkende straatnamen

  nwb_select$straatnaam_verschilt <- ifelse(nwb_select$straatnaam_string_dist >= 2,1,0)

  
  
  ##afwijkende gemeentes

  nwb_select$gemeentenaam_verschilt <- ifelse(nwb_select$gemeente_string_dist >=2,1,0)

  
  
  ##Sneller gereden dan Vmax
  
 
  nwb_select$sneller_gereden_dan_vmax<- ifelse(nwb_select$v_mean_dag > nwb_select$vmax,1,0)

  
  ##waar missen nwb lijnen tov osm waar ook veel gereden wordt

  nwb_select$mist_in_osm = ifelse(nwb_select$is_nn50 == FALSE,1,0 )
  

  
  
  
  ##waar missen nwb lijnen tov osm waar ook veel gereden wordt
  basemap_select$mist_in_nwb <-  ifelse(basemap_select$dekking_dag > 0.005 &  basemap_select$max_afstand_nwb >= 30,1,0)
  

  
  ##waar missen nwb lijnen tov osm waar ook veel gereden wordt

  nwb_select$mist_in_osm = ifelse(nwb_select$is_nn50 == FALSE,1,0 )

  
  
  
  ##Waar wijkt de vorm van het nwb af van die van het osm

  nwb_select$afwijkende_vorm <- ifelse( (nwb_select$max_afstand_osm  > 15) &   (nwb_select$mean_afstand_osm < 10) & nwb_select$afstand_osm_splitsing > 8,1,0)
  

  
  
  ##Rijrichting

  nwb_select$rijrichting_verschilt <- ifelse((nwb_select$twee_richting_OSM == 1  & !is.na(nwb_select$RIJRICHTNG)) |
                                               (nwb_select$twee_richting_OSM == 0  & is.na(nwb_select$RIJRICHTNG)) ,1,0 )

  
  
  
  ##Verdachte juncties

  nwb_select$verschil_junctie<- ifelse((nwb_select$afstand_osm_splitsing > 100 & nwb_select$vmax >= 80)  |
                                         (nwb_select$afstand_osm_splitsing > 30 & nwb_select$vmax < 80)
                                       ,1,0)
  
  out<- list()
  
  out$nwb_select <- nwb_select
  out$basemap_select <- basemap_select
  return(out)
  
}
