#################################################################################################################
#################################################################################################################
###
### Volume flow rate Calculations
###
#################################################################################################################

rowno <- 5              # Total number of rows in the array. Options: "3", "4"
nohairs <- 25            # Total number of hairs in the array. Options: "12", "18"
n <- 165				 # number of simulations to analyze

# Calculate leakiness base (no hairs condition)
domain <- 2.0		   	 # length of computational domain, m
dx <- 0.002       	     # Distance of mesh grid, m
hair_dia <- 0.002   	 	 # diameter of each hair, m
speed <- 0.06      	 	 # fluid speed, m/s
duration <- 0.03   	 	 # duration of simulation, s
sample <- 5000			 # sampling rate

half_sample = floor(sample/2)	 # Calculates the position of hair 1
shear_pt = floor(sample*(0.3*hair_dia+0.5*hair_dia)/domain) # Calculates distance of shear measurement from hair center

Uxmean<-matrix(data=0,nrow=n,ncol=3)
Uymean<-matrix(data=0,nrow=n,ncol=3)

for (j in 1:n){		# Main loop
	print(paste("Simulation: ",j,sep=""))					# Prints simulation number 
	
	# Construct directory name
	dirname<-paste("/Users/Bosque/IBAMR/entcode/code/runs/viz_IB2d",j,"/hairline_flux",sep="")
	# Sets working directory
	setwd(dirname)
	
	for (i in 1:3){
		
		# Loads final time-step data
		data <- read.table(paste("hairline_flux000",k[i],".curve",sep=""), header=FALSE, sep="")	
		
		Ux<-matrix(data=0,nrow=(sample),ncol=3)
		Uy<-matrix(data=0,nrow=(sample),ncol=3)
				
		#Calculate volume flow rate
		Ux[,i]<-data$V2[1:(sample)]*duration*-1
		Uy[,i]<-data$V2[(sample+1):2*(sample)]*duration*-1
		
		if (j==1&&i==1){plot(Ux[,i],type="l",col=cols[i],xlab="Dist along y",ylab="X-Component Velocity")
			}else{lines(Ux[,i],lty=1,col=cols[i],xlab="Dist along y",ylab="X-Component Velocity")}
		
		Uxmean[j,i]<-mean(Ux[,i])
		Uymean[j,i]<-mean(Uy[,i])
	}

}

plot(seq(1,n),Uxmean[,1],col=cols[1],pch=19,ylim=c(min(Uxmean),max(Uxmean)),
xlab="Simulation number",ylab="X-Component Velocity")
points(seq(1,n),Uxmean[,2],col=cols[2],pch=19)
points(seq(1,n),Uxmean[,3],col=cols[3],pch=19)

setwd("/Users/Bosque/IBAMR/entcode/code/runs/")	# Sets directory to main
# Saves leakiness values
write.table(Uxmean,file=paste("Uxmean",n,"-",Sys.Date(),".csv",sep=""),sep=",")
