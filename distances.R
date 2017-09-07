
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
dist2<- gDistance(base_select,nwb_select,densifyFrac = 0.1,byid = T,hausdorff = T)
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

library(leaflet)

leaflet() %>% addTiles()  %>% addPolylines(data=base_select,col="red",popup= ~paste("SegmentID:",SegmentID, "<br>",
                                                                             "OptimalSpeedKPH: ",OptimalSpeedKPH)) %>% 
  addPolylines(data=nwb_select,popup=~paste("WVK_ID: ",WVK_ID))

