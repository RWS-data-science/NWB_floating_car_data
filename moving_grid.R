library(data.table)
library(rgeos)
library(rgdal)

###Laad snelheden
library(foreign)
vmax_weggeg <- read.dbf("db/WEGGEG/01-06-2017/Maximum snelheid/max_snelheden.dbf")
vmax_weggeg<- vmax_weggeg[!duplicated(vmax_weggeg$WVK_ID),] #remove segments with >1 max speed

vmax_wkd<- read.csv("db/WKD/01-06-2017/Speed/Wegvakdeel N/MAX_SNELHEDEN.csv",sep="\t")
#vmax_wkd2<- read.csv("db/WKD/01-06-2017/Speed/Wegvakdeel J/MAX_SNELHEDEN.csv",sep="\t")
#vmax_wkd<- rbind(vmax_wkd,vmax_wkd2);rm(vmax_wkd2)
vmax_wkd$OMSCHR<- as.numeric(gsub("\\D", "", vmax_wkd$HDE_SHT))
vmax_wkd$WVK_ID<- vmax_wkd$WEGVAK_ID

vmax_merged<- rbind(vmax_weggeg[,c('WVK_ID','OMSCHR')],vmax_wkd[,c('WVK_ID','OMSCHR')])



load("db/dag_agg.RData")
load("db/nacht_agg.RData")


##LAad gemeentenamen
gemeenten <- readOGR("db/Bestuurlijkegrenzen-gemeenten-actueel-shp/Bestuurlijkegrenzen-gemeenten-actueel.shp")
#plot(gemeenten)
proj4string(gemeenten) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.999908 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +no_defs"
#gemeenten <- spTransform(gemeenten,proj4string(nwb_select))


#laad basemap
#basemap<- readOGR("db/basemaps/13354-shapes/segments.shp")
#save(basemap,file="db/basemap.RData")
load("db/basemap.RData")

wgs<- "+proj=longlat +ellps=WGS84 +datum=WGS84"
rd<- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.999908 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +no_defs"

proj4string(basemap)<- wgs

basemap_rd<- spTransform(basemap,rd)

#laad nwb



#nwb_full<- readOGR("db/NWB/01-06-2017/Wegvakken/Wegvakken.shp")
#proj4string(nwb_full)<- rd
#save(nwb_full,file="db/nwb_full_rd.RData")


#nwb_full<- spTransform(nwb_full,wgs)
#save(nwb_full,file="db/nwb_full_wgs.RData")
load("db/nwb_full_wgs.RData")
proj4string(nwb_full) <- wgs

min_x <- 3.5
max_x <- 7.1
x_inc <- 0.05

min_y <- 50.76
max_y <- 53.36
y_inc <- 0.02

# min_x <- 0
# max_x <- 300000 
# x_inc <- 1000
# 
# min_y <- 285000
# max_y <- 625000
# y_inc <- 1000


xs<- seq(min_x,max_x,by=x_inc)
ys<- seq(min_y,max_y,by=y_inc)

marge<- 0.001






moving_grid<- function (x){#for (i in 1:length(lons)){
  list2<- list()
  for (j in 1:length(ys)){
  
  xmin<- x-marge
  xmax<- x+x_inc + marge
  ymin<- ys[j]-marge
  ymax<- ys[j]+y_inc+marge
  coords = matrix(c(xmin, ymin,
                    xmax, ymin,
                    xmax, ymax,
                    xmin, ymax), 
                  ncol = 2, byrow = TRUE)
  
  #maak een vierkant tbv selectie
  P1 = Polygon(coords)
  
  Ps1 = SpatialPolygons(list(Polygons(list(P1), ID = "a")), proj4string=CRS(wgs))
  
  nwb_select<- nwb_full[Ps1,]
  
  
  if (nrow(nwb_select)>0 & nrow(basemap_select)>0){
    basemap_select<- basemap[Ps1,]
    list2[[j]] <- maak_shapefiles(nwb_select,basemap_select)
    }
  }
  return(list2)
  
  i<-1
  save(list2,file=paste0("db/moving_grid/deel",i,".RData"))
  print(i)
  i<- i+1
}

library(parallel)

# Calculate the number of cores
no_cores <- detectCores() - 1

# Initiate cluster
cl <- makeCluster(no_cores,type="FORK")

list<- parLapply(cl, xs,
                 moving_grid)

