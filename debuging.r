source('lib.r')

saveRDS(nwb_select_eq, 'db/nwb_select_eq.rds')
saveRDS(basemap_select_eq, 'db/basemap_select_eq.rds')


nwb_select_eq = readRDS("db/nwb_select_eq.rds")
basemap_select_eq = readRDS('db/basemap_select_eq.rds')




saveRDS(nwb_select, 'db/nwb_select.rds')
saveRDS(basemap_select, 'db/basemap_select.rds')


nwb_select = readRDS("db/nwb_select.rds")
basemap_select = readRDS('db/basemap_select.rds')

saveRDS(juncties, 'db/juncties.rds')



juncties = readRDS('db/juncties.rds')