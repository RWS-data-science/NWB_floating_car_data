library(rPython)







python.load("omrekenen.py")

python.assign( 'coords', c(91819, 437802))
python.exec('wgsCoords = conv.fromRdToWgs( coords )')
coords = python.get('wgsCoords')


python.assign('wgsCoords', coords)
python.exec('coords = conv.fromWgsToRd( wgsCoords )')
python.get('coords')


