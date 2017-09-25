# Generates grid for use with Constraint IB Method IBAMR
# GtD = gap to diameter ratio between hairs
# dist = distance from antennule
# theta = angle of center hair with positive x-axis
#

rm(list=ls())

require(pracma)
require(useful)

circle<-function(center,radius,L,dx){
	x_grid = seq(-radius,radius,by=dx)
	y_grid = seq(-radius,radius,by=dx)
	whole_grid = meshgrid(x_grid,y_grid)
	
	THETA=seq(0,2*pi,length=250)
	RHO=array(1,250)*radius
	points<-pol2cart(RHO,THETA,degrees=FALSE)
	
	In<-inpolygon(whole_grid$X,whole_grid$Y,points$x,points$y,boundary=FALSE)
	Xin<-whole_grid$X[In]
	Yin<-whole_grid$Y[In]
	
	X<-Xin+center[1]
	Y<-Yin+center[2]
	circ<-data.frame(X,Y)
	return(circ)
}

theta=0
L = 0.5         # length of computational domain (m)
N = 512        # number of Cartesian grid meshwidths at the finest level of the AMR grid
dx = (L/N)/(2)  # Cartesian mesh width (m)
# Notes ~ Rule of thumb: 2 boundary points per fluid grid point. 
#        vertex pts too far apart: flow thru boundary, too close: numerical weirdness
NFINEST = 4  # NFINEST = 4 corresponds to a uniform grid spacing of h=1/64

hdia = 0.01     # Diameter of hair
adia = 0.1     # Diameter of flagellum

theta = (theta/180)*pi      # Angle off positive x-axis in radians
GtD = 1.1      # Gap width to diameter ratio
dist = 0.01     # Distance between antennule and hair 
mindGap = (0.5*adia)+(0.5*hdia)+dist  # Calculate distance between hair centers
width = GtD*hdia+hdia

hair1Centerx = mindGap*cos(theta)
hair1Centery = mindGap*sin(theta)

hair2Centerx = hair1Centerx-width*sin(theta)
hair2Centery = hair1Centery+width*cos(theta)

hair3Centerx = hair1Centerx+width*sin(theta)
hair3Centery = hair1Centery-width*cos(theta)

kappa_target = 1.0e-2        # target point penalty spring constant (Newton)

#############################################################################
## All of the hairs

# Antennule
ant<-circle(c(0,0),0.5*adia,L,dx);
aN<-size(ant$X,2)
plot(Y~X,data=ant,xlim=c(0,0.17),ylim=c(-0.05,0.05))

# Hair 1
h1<-circle(c(hair1Centerx,hair1Centery),0.5*hdia,L,dx)
h1N<-size(h1$X,2)
points(Y~X,data=h1)
# Hair 2
h2<-circle(c(hair2Centerx,hair2Centery),0.5*hdia,L,dx)
h2N<-size(h2$X,2)
points(Y~X,data=h2)

# Hair 3
h3<-circle(c(hair3Centerx,hair3Centery),0.5*hdia,L,dx)
h3N<-size(h3$X,2)
points(Y~X,data=h3)

#############################################################################
## Write points to vertex file

totalN<-aN+h1N+h2N+h3N

filename<-"hairs2.vertex"
if(file.exists(filename)) file.remove(filename)
cat(as.character(totalN),sep="\n",file=filename,append=TRUE)
for (i in 1:aN){
cat(c(as.character(ant$X[i])," ",as.character(ant$Y[i]),"\n"),file=filename,sep="",append=TRUE)	
}
for (i in 1:h1N){
cat(c(as.character(h1$X[i])," ",as.character(h1$Y[i]),"\n"),file=filename,sep="",append=TRUE)	
}
for (i in 1:h2N){
cat(c(as.character(h2$X[i])," ",as.character(h2$Y[i]),"\n"),file=filename,sep="",append=TRUE)	
}
for (i in 1:h3N){
cat(c(as.character(h3$X[i])," ",as.character(h3$Y[i]),"\n"),file=filename,sep="",append=TRUE)	
}
