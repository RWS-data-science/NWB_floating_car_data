
library(shiny)
library(shinydashboard)
library(rgdal)
library(leaflet)

ui <- dashboardPage(
  dashboardHeader(title = "NWB vergelijker"),
  dashboardSidebar(
    
    sidebarMenu(
      menuItem("Geoviewer", tabName = "geo", icon = icon("map-o"))
    )
  ),
  
  
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "geo",
              h3("Vergelijk NWB met floating (car) data"),
              p("Geografische weergave van de meest recente versie van NWB wegvakken (blauw) en
                een voorbeeldbestand van floating data. In dit geval van afkomstig van Strava (fiets)."),
              leafletOutput("map"),
              checkboxInput("kaart","Achtergrondkaart",value=T),
              sliderInput("opa_nwb","Transparantie NWB:",0.7,min = 0,max=1,step = 0.05),
              sliderInput("opa_float","Transparantie floating data:",0.7,min = 0,max=1,step = 0.05),
              a(href="mailto:martijn.koole@rws.nl",icon("info-circle"),"Martijn Koole")
      )
    )
      
  )
)
