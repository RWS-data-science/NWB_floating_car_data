library(foreign)
base_full=read.dbf("db/basemaps/13354-shapes/segments.dbf")

source('merge_fcd.r')

dagen<- c(#"01","02","03","04","05","06",
  "07","08","09" ,"10")


for (dag in dagen){
  dir = paste0('db/06/',dag)
  uur1 = 9
  uur2 = 19

  tabel_overdag <- merge_tables(dir = dir,uur1 = uur1, uur2 = uur2)
  save(tabel_overdag,file=paste0('db/fcd_agg/',dag,'_dag.RData'))
  tabel_nacht =  merge_tables(dir = dir,uur1 = uur2, uur2 = uur1)
  save(tabel_nacht,file=paste0('db/fcd_agg/',dag,'_nacht.RData'))
}




parLapply(cl, 2:4,
          merge_tables,dir,uur1,uur2)