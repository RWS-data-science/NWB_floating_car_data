vmax_weggeg <- read.dbf("db/WEGGEG/01-06-2017/Maximum snelheid/max_snelheden.dbf")
vmax_weggeg<- vmax_weggeg[!duplicated(vmax_weggeg$WVK_ID),] #remove segments with >1 max speed

vmax_wkd<- read.csv("db/WKD/01-06-2017/Speed/Wegvakdeel N/MAX_SNELHEDEN.csv",sep="\t")
#vmax_wkd2<- read.csv("db/WKD/01-06-2017/Speed/Wegvakdeel J/MAX_SNELHEDEN.csv",sep="\t")
#vmax_wkd<- rbind(vmax_wkd,vmax_wkd2);rm(vmax_wkd2)
vmax_wkd$OMSCHR<- as.numeric(gsub("\\D", "", vmax_wkd$HDE_SHT))
vmax_wkd$WVK_ID<- vmax_wkd$WEGVAK_ID

vmax_merged<- rbind(vmax_weggeg[,c('WVK_ID','OMSCHR')],vmax_wkd[,c('WVK_ID','OMSCHR')])



nwb_select$vmax<- vmax_weggeg$OMSCHR[match(nwb_select$WVK_ID,vmax_merged$WVK_ID)]
nwb_select_wgs$vmax<- vmax_weggeg$OMSCHR[match(nwb_select_wgs$WVK_ID,vmax_merged$WVK_ID)]





##visualiseer snelheden

nwb_select_wgs$v_diff<- nwb_select_wgs$vmax - nwb_select_wgs$v_mean_dag

factpal <- colorFactor(c("green","black"), c(TRUE,FALSE))
factpal_nwb <- colorFactor(c("blue","red"), c(TRUE,FALSE))

colpal<- colorNumeric('Spectral',domain = nwb_select_wgs$v_diff)
#previewColors(colorNumeric('YlOrRd',domain = nwb_select_wgs$v_diff),c(0:100))

#####


wgs<- "+proj=longlat +ellps=WGS84 +datum=WGS84 +towgs84=0,0,0"

basemap_select_wgs<- spTransform(basemap_select,wgs)
nwb_select_wgs<- spTransform(nwb_select,wgs)

##leaflet
leaflet() %>% addProviderTiles(providers$CartoDB)  %>% 
  addPolylines(data=nwb_select_wgs,opacity=0.5,col=~colpal(v_diff),
               popup=~paste("WVK_ID: ",WVK_ID,"<br>",
                            "vmax: ", vmax,'<br>',
                            "v_mean_fcd_dag: ", v_mean_dag,'<br>',
                            "dekking: ",dekking,'<br>',
                            "nn_OSM_ID: ",nn_OSM),
               group="NWB",highlightOptions=highlightOptions(fillOpacity = 1,
                                                              bringToFront = TRUE) ) %>%

  addPolylines(data=basemap_select_wgs[which(basemap_select_wgs$segmentID == 2005584),],weight = 8,opacity=~dekking_scale,col=~factpal(ge50),group="OSM",
               popup= ~paste("SegmentID:",segmentID, "<br>",
                             "nn_nwb: ",nn_nwb_half, "<br>",
                             "half_hausdorff: ", hh_dist,"<br>",
                             "dekking: ",dekking),highlightOptions=highlightOptions(fillOpacity = 1,
                                                                                    bringToFront = TRUE)) %>%
  # Layers control
  addLayersControl(
    overlayGroups = c("NWB", "OSM"),
    options = layersControlOptions(collapsed = FALSE)) 

# addLegend("bottomright",bins = 5, pal = colpal, values=~v_diff,
#           title = "Speed difference",
#           opacity = 0.7)
    
