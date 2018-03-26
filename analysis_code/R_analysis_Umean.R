#################################################################################################################
#################################################################################################################
###
### Volume flow rate Calculations
###
#################################################################################################################

# Clears any previous data
rm(list=ls())

# Calculate leakiness base (no hairs condition)
domain = 2.0		   	 # length of computational domain, m
dx = 4.8828e-04       	     # Distance of mesh grid, m
hair_dia = 0.01   	 	 # diameter of each hair, m
speed = 0.06      	 	 # fluid speed, m/s
duration = 0.025   	 	 # duration of simulation, s

n = 27				 # number of simulations to analyze
	
setwd("/Volumes/HelmsDeep/IBAMR/entcode/usedruns/Umean")	# Sets directory to main

Umean<-matrix(data=0,nrow=n,ncol=3)

k<-c(6)
cols<-c("purple","blue","red")


for (j in 1:n){		# Main loop
	print(paste("Simulation: ",j,sep=""))					# Prints simulation number 
		
	for (i in 1:3){
		
		# Loads final time-step data
		data <- read.table(paste("Umag",j,"hair000",(i-1),".curve",sep=""), header=FALSE, sep="")	
		
		Umean[j,i]=data$V2[k]
		}
}

plot(seq(1,n),Umean[,1],col=cols[1],pch=19,ylim=c(min(Umean),max(Umean)),
xlab="Simulation number",ylab="Average Magnitude of Velocity")
points(seq(1,n),Umean[,2],col=cols[2],pch=19)
points(seq(1,n),Umean[,3],col=cols[3],pch=19)

setwd("/Volumes/HelmsDeep/IBAMR/entcode/usedruns/")	# Sets directory to main
# Saves leakiness values
write.table(Umean,file=paste("Umean",n,"-",Sys.Date(),".csv",sep=""),sep=",")
