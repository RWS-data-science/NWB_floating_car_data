#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

load("db/strava.RData")
load("db/nwb_select.RData")
# Define server logic required to draw a histogram
server<- function(input, output) {
  
opa_nwb<- reactive({input$opa_nwb})
opa_float<- reactive({input$opa_float})

output$map = renderLeaflet(    leaflet() %>% #addProviderTiles(providers$Esri.WorldGrayCanvas) %>%
                                 #clearShapes() %>%
                                 setView(lng = 4.65, lat = 52.025, zoom = 12) 
)

observe({
  if (input$kaart==T){
  leafletProxy("map") %>%
    addProviderTiles(providers$Esri.WorldGrayCanvas) %>%
    clearShapes() %>%
    addPolylines(data=strava,col="red",opacity = opa_float()) %>%
    addPolylines(data=nwb_select,weight = 5, opacity = opa_nwb(),popup= ~paste("WVK_ID: ",WVK_ID))
    
  }
  else {
    leafletProxy("map") %>%
      clearShapes() %>%
      addPolylines(data=strava,col="red",opacity = opa_float()) %>%
      addPolylines(data=nwb_select,weight = 5, opacity = opa_nwb(),popup= ~paste("WVK_ID: ",WVK_ID))
  }
    

})
}


   
