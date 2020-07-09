# Generates grid for use with Constraint IB Method IBAMR
# GtD = gap to diameter ratio between hairs
# dist = distance from antennule
# theta = angle of center hair with positive x-axis
#

#### Loads required packages ####
require(pracma)
require(useful)

rm(list=ls()) # Clears workspace

#### Defines functions ####
circle<-function(center,radius,L,dx){
	x_grid = seq(-radius,radius,by=dx)
	y_grid = seq(-radius,radius,by=dx)
	whole_grid = meshgrid(x_grid,y_grid)
	
	THETA=c(seq(0,2*pi,length=250),0)
	RHO=array(1,length(THETA))*radius
	Z = array(1,length(RHO))*0
	nap<-matrix(c(THETA,RHO),nrow=length(THETA),ncol=2)
	points<-pol2cart(RHO,THETA)
	points<-as.data.frame(points)
	
	In<-inpolygon(whole_grid$X,whole_grid$Y,points$x,points$y,boundary=FALSE)
	Xin<-whole_grid$X[In]
	Yin<-whole_grid$Y[In]
	
	X<-Xin+center[1]
	Y<-Yin+center[2]
	circ<-data.frame(X,Y)
	return(circ)
}

##### Input parameter definitions ####

th=0
L = 2.0         # length of computational domain (m)
N = 1024        # number of Cartesian grid meshwidths at the finest level of the AMR grid
dx = 1.0*(L/N)  # Cartesian mesh width (m)
# Notes ~ Rule of thumb: 2 boundary points per fluid grid point. 
#        vertex pts too far apart: flow thru boundary, too close: numerical weirdness
NFINEST = 4  # NFINEST = 4 corresponds to a uniform grid spacing of h=1/64
kappa_target = 1.0e-2        # target point penalty spring constant (Newton)

hdia = 0.01     # Diameter of hair
adia = 0.1     # Diameter of flagellum

th2 = (th/180)*pi      # Angle off positive x-axis in radians
GtD = 6.0787      # Gap width to diameter ratio
dist = 0.02     # Distance between antennule and hair 
mindGap = (0.5*adia)+(0.5*hdia)+dist  # Calculate distance between hair centers
width = GtD*hdia+hdia

#### Calculates center positions (x,y) of each hair ####
hair1Centerx = mindGap*cos(th2)
hair1Centery = mindGap*sin(th2)

hair2Centerx = hair1Centerx-width*sin(th2)
hair2Centery = hair1Centery+width*cos(th2)

hair3Centerx = hair1Centerx+width*sin(th2)
hair3Centery = hair1Centery-width*cos(th2)

hair4Centerx = hair1Centerx+width*cos((30/180)*pi)
hair4Centery = hair1Centery+width*sin((30/180)*pi)

hair5Centerx = hair1Centerx+width*cos((30/180)*pi)
hair5Centery = hair1Centery-width*sin((30/180)*pi)


#### Produces points within defined hairs ####

# Antennule
ant<-circle(c(0,0),0.5*adia,L,dx);  # Produces points that define antennule
aN<-size(ant$X,2)                   # Records number of points inside antennule
plot(Y~X,data=ant,xlim=c(-0.25,0.25),ylim=c(-0.25,0.25),pch=19) #Plots antennule

# Hair 1
h1<-circle(c(hair1Centerx,hair1Centery),0.5*hdia,L,dx)
h1N<-size(h1$X,2)
points(Y~X,data=h1,pch=19)

# Hair 2
h2<-circle(c(hair2Centerx,hair2Centery),0.5*hdia,L,dx)
h2N<-size(h2$X,2)
points(Y~X,data=h2,pch=19)

# Hair 3
h3<-circle(c(hair3Centerx,hair3Centery),0.5*hdia,L,dx)
h3N<-size(h3$X,2)
points(Y~X,data=h3,pch=19)

# Hair 4
h4<-circle(c(hair4Centerx,hair4Centery),0.5*hdia,L,dx)
h4N<-size(h4$X,2)
points(Y~X,data=h4,pch=19)

# Hair 5
h5<-circle(c(hair5Centerx,hair5Centery),0.5*hdia,L,dx)
h5N<-size(h5$X,2)
points(Y~X,data=h5,pch=19)


#### Write points to vertex file ####

totalN<-aN+h1N+h2N+h3N+h4N+h5N  # Calculates total number of points (first line of vertex file)

filename<-"hairs2.vertex"   # Defines file name
if(file.exists(filename)) file.remove(filename)  # Deletes file with that name if it exists
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
for (i in 1:h4N){
  cat(c(as.character(h4$X[i])," ",as.character(h4$Y[i]),"\n"),file=filename,sep="",append=TRUE)
}

for (i in 1:h5N){
  cat(c(as.character(h5$X[i])," ",as.character(h5$Y[i]),"\n"),file=filename,sep="",append=TRUE)
}


