library(shiny)
library(leaflet)
library(sp)
load("db/basemap_select_wgs.RData")
load("db/nwb_select_wgs.RData")
#load("db/dist_matrix.RData")

runApp("nwb_fcd_demo")


install.packages('rsconnect')
rsconnect::setAccountInfo(name='koolem',
                          token='493B4E9CD43658CF669D60EE68F1A169',
                          secret='1HBOjetNuwP6yAOuc2aazgdI+xVb3Pt1J3jH538F')
library(rsconnect)
rsconnect::deployApp('nwb_fcd_demo')
