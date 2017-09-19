#filename = 'db/shape/Wegvakken.shx'
#shape = readOGR(filename)






# #test voor 1 line
# lines = shape@lines
# lines= lines[1:1000]
# pad = lines[[256]]@Lines[[1]]@coords
# 
# lengte = 10



#maak vector met afstand tot begin van ieder punt
spacing = function(lengte, pad){


n_rijen = nrow(pad)
verschil = pad - rbind( pad,  pad[ n_rijen ,] )[-1,]
verschil = rbind(c(0,0),verschil[-nrow(verschil),] )
afstand = sqrt(verschil[,1]^2 + verschil[,2]^2)


f_1 = approxfun(cumsum(afstand),pad[,1], rule = 2)
f_2 = approxfun(cumsum(afstand),pad[,2], rule = 2)

#interpoleer de functie
afstand_totaal = sum(afstand)
aantal = floor(afstand_totaal/lengte)


if(aantal>0){
stap = afstand_totaal/aantal
stapjes = stap * c(0:aantal)
x = f_1(stapjes)
y = f_2(stapjes)

output = cbind(x,y)

output = rbind(output, pad[n_rijen,])

return(output)
}else{
  return(pad)
}

}


  
  


