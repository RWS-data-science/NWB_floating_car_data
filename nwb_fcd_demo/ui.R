 #
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


#library(shiny)
#require(leaflet)

# Define UI for application that draws a histogram
ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                selectInput("fout", "Type verschil:", choices =  c(
                                                                   "Ontbreekt in NWB" =  "Mist_NWB",
                                                                   "Ontbreekt in OSM" = "Mist_OSM",
                                                                   "Straatnaam" = "Straatnaam",
                                                                   "Gemeentenaam" = "Gemeentenaam",
                                                                   "Rijrichting" = "Rijrichting",
                                                                   "Snelheid" = "Snelheid",
                                                                   "Junctie" = "Junctie")
                )
  )

                  

)
