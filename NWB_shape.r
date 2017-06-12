library(rgdal)
library(sp)
library(tmap)
library(sf)

shape <- readRDS('db/shape.rds')



proj4string(shape)


for(i in 1:nrow(shape@data)){

  print(paste('wegvak ID:', shape@data$WVK_ID[i]))
  
  xrand = c( min(coordinates(shape[i,])[[1]][[1]][,1]), max(coordinates(shape[i,])[[1]][[1]][,1])) 
  yrand = c( min(coordinates(shape[i,])[[1]][[1]][,2]), max(coordinates(shape[i,])[[1]][[1]][,2])) 

  xrand[1] = xrand[1] -  0.3*(xrand[2] - xrand[1])
  xrand[2] = xrand[2] +  0.3*(xrand[2] - xrand[1])
  
  yrand[1] = yrand[1] -  0.3*(yrand[2] - yrand[1])
  yrand[2] = yrand[2] +  0.3*(yrand[2] - yrand[1])
  
  
  
  png(paste0(filename="db/wegvak_plaatjes/", i ))
 
  
  plot(x= xrand, y = yrand, col = 'red')
  plot(shape[i,], add = TRUE)
  
  
  dev.off()
  
  plot(x= xrand, y = yrand, col = 'red')
  plot(shape[i,], add = TRUE)
  browser()

  }


