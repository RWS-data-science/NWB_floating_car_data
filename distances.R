
##voor splitten
library(rgeos)
dist<- gDistance(base_select,nwb_select,byid = T,hausdorff = T)
#dist<- as.numeric(dist)
mindist<- apply(dist,2,min)
whichmindist<- apply(dist,2,which.min)

nn.df<- data.frame(osm_id = base_select$SegmentID,nn_nwb = nwb_select$WVK_ID[whichmindist],
                   dist = mindist)

library(ggplot2)
png()
ggplot(nn.df,aes(x=dist))+geom_histogram()+ggtitle("Distribution of distances to nearest neighbor \n before splitting")


##
dist2<- gDistance(base_select,nwb_select,densifyFrac = 0.2,byid = T,hausdorff = T)
#dist<- as.numeric(dist)
mindist2<- apply(dist2,2,min)
whichmindist2<- apply(dist2,2,which.min)

#nn.df2<- data.frame(osm_id = base_select$SegmentID,nn_nwb = nwb_select$WVK_ID[whichmindist2],
#                   dist = mindist2)

nn.df$nn_nwb_split<- nwb_select$WVK_ID[whichmindist2]
nn.df$dist_split<- mindist2

#png()
ggplot(nn.df,aes(x=dist))+geom_histogram(aes(x=dist),fill="red",alpha=0.3)+geom_histogram(aes(x=dist_split),fill ="blue",alpha=0.3)+
  ggtitle("Distribution of distances to nearest neighbor")

base_select$nn_nwb<- nn.df$nn_nwb[match(base_select$SegmentID,nn.df$osm_id)]

##back to wgs
wgs<- "+proj=longlat +ellps=WGS84 +datum=WGS84 +towgs84=0,0,0"

base_select_wgs<- spTransform(base_select,wgs)
nwb_select_wgs<- spTransform(nwb_select,wgs)

base_select_wgs<- base_select_wgs[order(base_select_rd$nn_nwb),]
nwb_select_wgs<- nwb_select_wgs[order(nwb_select_rd$WVK_ID),]

color = grDevices::colors()[grep('gr(a|e)y', grDevices::colors(), invert = T)]
factpal <- colorFactor(sample(color,1000,replace = T), factor(base_select$nn_nwb))

library(leaflet)
leaflet() %>% addTiles()  %>% 
  addPolylines(data=nwb_select_rd,opacity=0.5,col=~factpal(factor(WVK_ID)),popup=~paste("WVK_ID: ",WVK_ID),group="NWB") %>% 
  addPolylines(data=base_select_rd,weight = 5,opacity=0.5,dashArray="2",col=~factpal(factor(nn_nwb)),group="OSM",
                                           popup= ~paste("SegmentID:",SegmentID, "<br>",
                                                         "nn_nwb: ",nn_nwb)) %>%
  # Layers control
  addLayersControl(
    overlayGroups = c("NWB", "OSM"),
    options = layersControlOptions(collapsed = FALSE)
  )



###half hausdorf
source('half_hausdorf.r')
OSM = base_select
NWB = nwb_select

distance_lijst = pblapply(c(1:length(OSM@lines)), function(i){
  
  hausdorf_distances_to_NWB_lines =   lapply(c(1:length(NWB@lines)),function(j){
    half_hausdorf(OSM@lines[[i]]@Lines[[1]]@coords, NWB@lines[[j]]@Lines[[1]]@coords  )
  })
  
  
  minimum_distance = min(unlist( hausdorf_distances_to_NWB_lines))
  label = which.min( unlist(hausdorf_distances_to_NWB_lines) )
  
  return(c(OSM$SegmentID[i],as.numeric(as.character(NWB$WVK_ID[label])), minimum_distance))
})


distance_matrix = as.data.frame(do.call(rbind, distance_lijst))[,c(1:3)]
#distance_matrix = as.data.frame(distance_matrix)[,c(1:3)]


colnames(distance_matrix) = c('OSM_id', 'NWB_id', 'Half_Hausdorfdistance')

nn.df$nn_nwb_half<- distance_matrix$NWB_id[match(nn.df$osm_id,distance_matrix$OSM_id)]
nn.df$dist_half<- distance_matrix$Half_Hausdorfdistance[match(nn.df$osm_id,distance_matrix$OSM_id)]

#check difference between methods
nn.df$diff<- as.integer(as.character(nn.df$nn_nwb)) - nn.df$nn_nwb_half


##nieuw visualisatie
nn.df$ge50<- ifelse(nn.df$dist_half >=50, TRUE,FALSE)


base_select$nn_nwb_half<- nn.df$nn_nwb_half[match(base_select$SegmentID,nn.df$osm_id)]
base_select$ge50<- nn.df$ge50[match(base_select$SegmentID,nn.df$osm_id)]

##back to wgs
wgs<- "+proj=longlat +ellps=WGS84 +datum=WGS84 +towgs84=0,0,0"

base_select_wgs<- spTransform(base_select,wgs)
nwb_select_wgs<- spTransform(nwb_select,wgs)

base_select_wgs<- base_select_wgs[order(base_select_wgs$nn_nwb),]
nwb_select_wgs<- nwb_select_wgs[order(nwb_select_wgs$WVK_ID),]

factpal <- colorFactor(c("green","black"), c(TRUE,FALSE))
##leaflet
leaflet() %>% addProviderTiles(providers$CartoDB.Positron)  %>% 
  addPolylines(data=nwb_select_wgs,opacity=0.5,col="red",popup=~paste("WVK_ID: ",WVK_ID),group="NWB") %>% 
  addPolylines(data=base_select_wgs,weight = 5,opacity=0.5,col=~factpal(ge50),group="OSM",
               popup= ~paste("SegmentID:",SegmentID, "<br>",
                             "nn_nwb: ",nn_nwb)) %>%
  # Layers control
  addLayersControl(
    overlayGroups = c("NWB", "OSM"),
    options = layersControlOptions(collapsed = FALSE)
  )


