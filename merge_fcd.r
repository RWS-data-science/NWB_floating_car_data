dir = 'db/fcd'

tabel = merge_tables(dir)


merge_tables = function(dir){


files = list.files(dir)

tabel = read.table( paste(dir , files[1], sep = '/') , sep = ';', skip = 1, header = TRUE)


for(i in 2:length(files)){

  #lees nieuwe tabel in
tabel_nieuw = read.table( paste(dir , files[i], sep = '/') , sep = ';', skip = 1, header = TRUE)
colnames(tabel_nieuw)[2:5] = paste(colnames(tabel_nieuw)[2:5], 'nieuw', sep = '_'  )

#merge nieuwe tabel met de oude
tabel =  merge(x = tabel, y = tabel_nieuw, key = 'SegmentID', all.x = TRUE, all.y = TRUE)

#stel coverage en speed bij
tabel[is.na(tabel)] = 0
tabel_nieuw[is.na(tabel_nieuw)] = 0
tabel$SpeedKph = tabel$SpeedKph+ tabel$SpeedKph_nieuw* tabel$Coverage_nieuw
tabel$Coverage = tabel$Coverage  + tabel$Coverage_nieuw 

#verwijder de nieuwe kolomen weer
tabel$Coverage_nieuw = NULL
tabel$SpeedKph_nieuw = NULL
tabel$LOS.Reference_nieuw = NULL
tabel$TraveltimeMS_nieuw = NULL

}

#neem gemiddelde van snelheid
tabel$SpeedKph = tabel$SpeedKph / tabel$Coverage

return(tabel)
}