#################################################################################################################
#################################################################################################################
###
### Leakiness and Shear Calculations
###
#################################################################################################################

# Clears any previous data
rm(list=ls())

# Calculate leakiness base (no hairs condition)
domain = 2.0		   	 # length of computational domain, m
dx = 0.0003255208       	     # Distance of mesh grid, m
hair_dia = 0.01   	 	 # diameter of each hair, m
speed = 0.06      	 	 # fluid speed, m/s
duration = 0.03   	 	 # duration of simulation, s
sample = 5000			 # sampling rate
arrayrow<-2   # number of array row

half_sample = floor(sample/2)	 # Calculates the position of hair 1
#shear_pt = floor(sample*(0.3*hair_dia+0.5*hair_dia)/domain) # Calculates distance of shear measurement from hair center

n = 12				 # number of simulations to analyze
	
dirname<-"/Users/waldrop/Dropbox (Chapman)/EntIBAMR/entcode/"	# Sets directory to main
setwd(dirname)
gaps<-read.table("analysis_code/gapwidths.txt",sep="")			# Loads file with gapwidth values in main directory

leakiness = rep(0,n)					# Allocates space for leakiness calculation
# shear_hair<-data.frame(seq(1,n),seq(1,n),seq(1,n),seq(1,n),seq(1,n),seq(1,n))	# Allocates space for shear calculations
# names(shear_hair)<-c("hair1top","hair1bottom","hair2top","hair2bottom","hair3top","hair3bottom")

#par(mfrow=c(1,3))
plot(c(0),ylim=c(-0.1,0.1),xlim=c(0,sample))	# Optional plotting for running data

for (j in 1:n){		# Main loop
	print(paste("Simulation: ",j,sep=""))					# Prints simulation number 
	# Construct directory name
	dirname2<-paste(dirname,"runs/viz_IB2d",j,"/hairline",arrayrow,sep="")
	# Sets working directory
	setwd(dirname2)
	# Loads final time-step data
	data1 <- read.table("hairline0003.curve", header=FALSE, sep="")	
	points(data1$V2,pch=19)
	# Calculates bottom of leakiness ratio based on hair spacing for each simulation
	#gapshere<-floor(sample*(gaps$V1[j]/domain))			# Calculates the gap distance in sampling units
	#range_low<-half_sample-gapshere						# Establishes low point in sampling range 
	#range_high<-half_sample+gapshere					# Establishes high point in sampling range
	samplewidth<-gaps$V1[j]/sample
	leak_bot = (speed*duration)*(gaps$V1[j])	# Calculates bottom of leakiness ratio
	
	data2=rep(0,length(data1$V1))		# Allocates space for leakiness calculation
	
	for (i in 1:sample+1){	# Loop that cycles through each sampled point in a simulation
	  data2[i]=(data1$V2[i]*duration*samplewidth)	# Calculates top of leakiness for each sampled point
	}
	leakiness[j]=sum(data2)/leak_bot	# Calculates leakiness value for each simulation
	rm(data2)
	# Calculates shear shear_pt away from center of hair
	# hair1t<-half_sample+shear_pt
	# shear_hair$hair1top[j]<-data1$V2[hair1t]/speed
	# hair1b<-half_sample-shear_pt-1
	# shear_hair$hair1bottom[j]<-data1$V2[hair1b]/speed
	# 
	# hair2t<-range_high+shear_pt
	# shear_hair$hair2top[j]<-data1$V2[hair2t]/speed
	# hair2b<-range_high-shear_pt-1
	# shear_hair$hair2bottom[j]<-data1$V2[hair2b]/speed	
	# 
	# hair3t<-range_low+shear_pt
	# shear_hair$hair3top[j]<-data1$V2[hair3t]/speed
	# hair3b<-range_low-shear_pt-1
	# shear_hair$hair3bottom[j]<-data1$V2[hair3b]/speed
		

}

setwd(paste(dirname,"runs/",sep=""))	# Sets directory back to main
plot(leakiness,ylim=c(0,max(leakiness)))		# Plots final values of leakiness for each simulation

# plot(shear_hair$hair1top,ylim=c(0,2),pch=21, col="purple",bg="purple")
# points(shear_hair$hair1bottom,pch=21, col="purple")
# points(shear_hair$hair2top,pch=21,col="red",bg="red")
# points(shear_hair$hair2bottom,pch=21,col="red")
# points(shear_hair$hair3top,pch=21,col="blue",bg="blue")
# points(shear_hair$hair3bottom,pch=21,col="blue")

# Saves leakiness values
write.table(leakiness,file=paste("leakiness-row",arrayrow,"-",n,"-",Sys.Date(),".csv",sep=""),sep=",")
# write.table(shear_hair,file=paste("shear_hair",n,"-",Sys.Date(),".csv",sep=""),sep=",")
#################################################################################################################