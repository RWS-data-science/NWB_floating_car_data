#all libraries
source('lib.r')




#convert shape to wgs
filename = 'db/shape/Wegvakken.shx'
shape = readOGR(filename)
source('omrekenen.r')
shape = omrekenen(shape)


#generic function to turn a shape into a shape file with equally distance points
source('prepare_shape.r')

#function to make a neigrest neighbour table from two point files

#A function to match lines in two shape files with help of the neighrest neighbour table of the points that where added to the lines in step 1




