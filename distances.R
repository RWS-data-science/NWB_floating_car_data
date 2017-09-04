#nearest neighbor

#require(FNN)
##g = get.knnx(coordinates(uk_coord), coordinates(ire_coord),k=1)
#str(g)
#List of 2
#$ nn.index: int [1:69, 1] 202 488 202 488 253 253 488 253 253 253 ...
#$ nn.dist : num [1:69, 1] 232352 325375 87325 251770 203863 ...

##change proj to RD
base_select<- Sldf
proj4string(base_select)<- "+proj=longlat +ellps=WGS84 +datum=WGS84 +towgs84=0,0,0"
rd<- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.999908 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +no_defs"

nwb_select<- spTransform(nwb_select,rd)
base_select<- spTransform(base_select,rd)


library(rgeos)
dist<- gDistance(base_select,nwb_select,byid = T,hausdorff = T)
dist<- as.numeric(dist)
mindist<- apply(dist,2,min)
whichmindist<- apply(dist,2,which.min)

nn.df<- data.frame(osm_id = base_select$SegmentID,nn_nwb = nwb_select$WVK_ID[whichmindist],
                   dist = mindist)

