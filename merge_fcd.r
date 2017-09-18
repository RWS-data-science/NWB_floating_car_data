dir = 'db/fcd'
tijd1 = as.POSIXct( '2016-01-01 06:00:00', "%Y-%m-%d %H:%M:%S")
tijd2 = as.POSIXct( '2016-01-01 19:00:00', "%Y-%m-%d %H:%M:%S")

tabel = merge_tables(dir = dir, tijd1 = tijd1, tijd2 = tijd2)





merge_tables = function(dir, tijd1, tijd2){


files = list.files(dir)

#initialiseer starttabel
tabel = data.frame('SegmentID' = -1) 




for(i in 1:length(files)){

  #lees nieuwe tabel in

  tijd = strsplit(readLines(paste(dir , files[i], sep = '/'), n = 1), '[:;]' )
  tijd = paste0('2016-01-01 ',tijd[[1]][[2]], ':', tijd[[1]][[3]], ':00')
  tijd = as.POSIXct(tijd, "%Y-%m-%d %H:%M:%S")
  
  if(tijd > tijd1 & tijd < tijd2){ #als de tijd tussen de ingegeven grenzen valt voeg dan de informatie toe
  
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

}#einde if

}

#neem gemiddelde van snelheid
tabel$SpeedKph = tabel$SpeedKph / tabel$Coverage

return(tabel)
}