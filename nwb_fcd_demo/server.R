#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
require(leaflet)



# Define server logic required to draw a histogram
server<- function(input, output,session) {
  load("basemap_select_wgs.RData")
  load("nwb_select_wgs.RData")
  

  base<- reactive({
    
    #distance_matrix$trigger<- ifelse(distance_matrix$Half_Hausdorfdistance >=50, TRUE,FALSE) #hh distance greater than or equal to 50 m
    
  
    #basemap_select_wgs$nn_nwb_half<- distance_matrix$NWB_id[match(basemap_select_wgs$segmentID,distance_matrix$OSM_id)]
    basemap_select_wgs_2$trigger<- ifelse(basemap_select_wgs_2$hh_dist>= input$distance,TRUE,FALSE)
    basemap_select_wgs_2
   # basemap_select_wgs$hh_dist<- distance_matrix$Half_Hausdorfdistance[match(basemap_select_wgs$segmentID,distance_matrix$OSM_id)]

  })

  nwb<- reactive({
    nwb_select_wgs_2$is_nn_dist<- ifelse(nwb_select_wgs_2$WVK_ID %in% basemap_select_wgs_2$nn_nwb_half[basemap_select_wgs_2$hh_dist< input$distance ],TRUE,FALSE )
    nwb_select_wgs_2
  })
  

  
  output$map <- renderLeaflet({
    
    factpal <- colorFactor(c("green","black"), c(TRUE,FALSE))
    factpal_nwb <- colorFactor(c("red","blue"), c(TRUE,FALSE))
    

    ##leaflet
    leaflet() %>% addProviderTiles(providers$CartoDB)  %>% 
    addPolylines(data=nwb(),
                 opacity=0.5,col=~factpal_nwb(is_nn50),
                 popup=~paste("WVK_ID: ",WVK_ID),group="NWB" ) %>%
      
    addPolylines(data=base(),
                 weight = 5,opacity=0.5,col=~factpal(ge50),group="OSM",
                 popup= ~paste("SegmentID:",segmentID, "<br>",
                               "nn_nwb: ",nn_nwb_half, "<br>",
                               "half_hausdorff: ", hh_dist)) %>%
    # Layers control
    addLayersControl(position = "bottomleft",
      overlayGroups = c("NWB", "OSM"),
      options = layersControlOptions(collapsed = FALSE)) %>%
    
    addLegend("bottomright", colors = c("chartreuse","black","blue","red"), labels = c("Wel in OSM, ook in NWB","Wel in OSM, niet NWB",
                                                                                       "Wel in NWB, ook in OSM","Wel in NWB, niet in OSM"),
              title = "Legend",
              opacity = 0.7)
    
  })
  
}

############
