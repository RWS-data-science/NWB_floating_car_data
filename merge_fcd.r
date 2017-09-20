



merge_tables = function(dir, uur1, uur2){

#maak vector van de uren die we meenemen
  if(uur1<uur2){
uren = uur1:uur2
  }else{
    uren = c(uur1:23, 0:uur2)
  }
  

#zoek alle files in de directory
files = list.files(dir)

#initialiseer starttabel
#tabel = data.frame('SegmentID' = -1,'Coverage_totaal' = 0  ,'SpeedKph_totaal' = 0, 'aantal_keer_totaal' = 0) 

tabel= data.frame('SegmentID'=base_full$segmentID,'Coverage_totaal' = 0  ,'SpeedKph_totaal' = 0, 'aantal_keer_totaal' = 0)



for(i in 1:length(files)){
a<-Sys.time()
  #lees de tijd van de nieuwe tabel
  tijd = as.numeric(strsplit(readLines(paste(dir , files[i], sep = '/'), n = 1), '[:;T]' )[[1]][[2]])
 
  
  if(tijd %in% uren){ #als de tijd tussen de ingegeven grenzen valt voeg dan de informatie toe
  
tabel_nieuw = fread( paste('zcat <',paste(dir , files[i], sep = '/')) , sep = ';', skip = 1, header = TRUE)

tabel_nieuw$aantal_keer = 1

#merge nieuwe tabel met de oude
#tabel =  merge(x = tabel, y = tabel_nieuw, key = 'SegmentID', all.x = TRUE, all.y = TRUE)
tabel$SpeedKph <- tabel_nieuw$SpeedKph[match(tabel$SegmentID,tabel_nieuw$SegmentID)] 
tabel$Coverage <- tabel_nieuw$Coverage[match(tabel$SegmentID,tabel_nieuw$SegmentID)] 
tabel$aantal_keer<- tabel_nieuw$aantal_keer[match(tabel$SegmentID,tabel_nieuw$SegmentID)] 

#stel coverage en speed bij
tabel[is.na(tabel)] = 0
#tabel_nieuw[is.na(tabel_nieuw)] = 0
tabel$SpeedKph_totaal = tabel$SpeedKph_totaal+ tabel$SpeedKph#* tabel$Coverage
tabel$Coverage_totaal = tabel$Coverage_totaal  + tabel$Coverage
tabel$aantal_keer_totaal = tabel$aantal_keer_totaal + tabel$aantal_keer

#verwijder kolomen 
tabel$Coverage = NULL
tabel$SpeedKph = NULL
tabel$LOS.Reference = NULL
tabel$TraveltimeMS = NULL
tabel$aantal_keer = NULL

}#einde if
#print(Sys.time()-a)
}

#neem gemiddelde van snelheid
tabel$SpeedKph = tabel$SpeedKph_totaal / tabel$aantal_keer_totaal

#gooid segmentID van -1 weg
tabel = tabel[ - which(tabel$SegmentID==-1),] 




return(tabel)
}