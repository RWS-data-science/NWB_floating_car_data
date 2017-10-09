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

#c("Mist_NWB","Mist_OSM","Straatnaam","Gemeentenaam","Rijrichting","Snelheid","Junctie")

# Define server logic required to draw a histogram
server<- function(input, output,session) {
  #load("basemap_select_wgs.RData")
  
  


    nwb<- reactive({
    if (input$fout == "Mist_OSM"){
      nwb_select_wgs[which(nwb_select_wgs$mist_in_osm == 1),]
    } else if (input$fout == "Straatnaam"){
      nwb_select_wgs[which(nwb_select_wgs$straatnaam_verschilt == 1),]
    } else if (input$fout == "Gemeentenaam"){
      nwb_select_wgs[which(nwb_select_wgs$gemeentenaam_verschilt == 1),]
    } else if (input$fout == "Snelheid"){
      nwb_select_wgs[which(nwb_select_wgs$sneller_gereden_dan_vmax == 1),]
    } else if (input$fout == "Rijrichting"){
      nwb_select_wgs[which(nwb_select_wgs$rijrichting_verschilt == 1),]  
    } else{
      nwb_select_wgs
    }
    })
  

  
  output$map <- renderLeaflet({
    
    colpal<- colorNumeric('Spectral',domain = nwb_select_wgs$v_diff_dag)
    
    ##leaflet straatnamen
    leaflet() %>% addProviderTiles(providers$CartoDB)  %>% 
      addPolylines(data=nwb(),opacity=~dekking_dag_scale,#,col=~colpal(v_diff_dag),
                   popup=~paste("<b> WVK_ID: </b>",WVK_ID,"<br>",
                                "<b> Gemiddeld gereden snelheid overdag: </b>", round(v_mean_dag,2),"<br>",
                                "<b> v_max WEGGEG/WKD: </b>", vmax, "<br>",
                                "<b> v_max OSM: </b>", vmax_OSM, "<br>",
                                "<b> dekking_dag: </b>",round(dekking_dag,2), "<br>",
                                "<b> STT_NAAM NWB: </b>", STT_NAAM, "<br>",
                                "<b> Straatnaam OSM: </b>",straatnaam_OSM,"<br>",
                                "<b> GME_NAAM NWB: </b>",GME_NAAM, "<br>",
                                "<b> Gemeente volgens CBS: </b>", gemeente_check, "<br>",
                                "<b> Rijrichting NWB: </b>", RIJRICHTNG, "<br>",
                                "<b> Tweerichtingsverkeer volgens OSM: </b>", twee_richting_OSM
                                )
                   )
                   
    
  })
  observe({
    proxy <- leafletProxy("map",data=basemap_select_wgs)
    
    # Remove any existing legend, and only if the legend is
    # enabled, create a new one.
    proxy %>% clearControls()
    if (input$fout == "Mist_OSM") {
      #pal <- colorpal()
      proxy %>% addPolylines(data=basemap_select_wgs,col="red")
    } else if (input$fout == "Mist_NWB"){
      proxy %>% addPolylines(data=basemap_select_wgs[which(basemap_select_wgs$mist_in_nwb == 1),],col="red")
    }
  })
  
}

############
