#################################################################################################################
#################################################################################################################
###
### Leakiness Calculations
###
#################################################################################################################

rm(list=ls()) # Clears any previous data

#### Assign condition values ####
norows<-4              # Total number of rows in the array. Options: "3", "4"
nohairs<-18            # Total number of hairs in the array. Options: "12", "18"
dirname<-"/Users/waldrop/Dropbox (Chapman)/EntIBAMR/entcode/"	
rundir<-"runs/"   # Runs directory. Options: "runs_3row/", "runs/"

n = 165				 # number of simulations to analyze

speed = 0.06      	 	 # fluid speed, m/s
duration = 0.03   	 	 # duration of simulation, s
sample = 5000			 # sampling rate
leakiness<-matrix(data=0,nrow=n,ncol=norows)	# Allocates space for leakiness calculation

setwd(dirname) # Sets directory to main

#### Main Loop for Calculations ####
for (j in 1:n){		# Main loop
	print(paste("Simulation: ",j,sep=""))					# Prints simulation number 
  for (arrayrow in 1:norows){
    dirname2<-paste(dirname,rundir,"viz_IB2d",j,"/hairline",arrayrow,"/",sep="") # Construct directory name
    data1 <- read.table(paste(dirname2,"hairline0003.curve",sep=""), header=FALSE, sep="")	# Loads final time-step data
	  rowwidth<-data1$V1[sample+1]-data1$V1[1]
	  samplewidth<-rowwidth/sample # Calculates real width between sample points
	  leak_bot = (speed*duration)*rowwidth	# Calculates bottom of leakiness ratio
	  data2=rep(0,length(data1$V1))		# Allocates space for leakiness calculation
	  
	  for (i in 1:sample+1){	# Loop that cycles through each sampled point in a simulation
	    data2[i]=(data1$V2[i]*duration*samplewidth)	# Calculates top of leakiness for each sampled point
	  }
	  leakiness[j,arrayrow]<-sum(data2)/leak_bot	# Calculates leakiness value for each simulation
	  rm(data2)
  }
}


#plot(leakiness,ylim=c(0,1))		# Plots final values of leakiness for each simulation

leakiness2<-data.frame(leakiness)
leaknames<-as.character(rep(0,norows)) # Allocates space for names 
for (i in 1:norows){leaknames[i]<-paste("row",i,sep="")} # Assigns name for each hair
names(leakiness2)<-leaknames # Assigns all names to data frame

setwd(paste(dirname,rundir,sep=""))	# Sets directory back to main
# Saves data!
write.table(leakiness2,file=paste("leakiness-",n,"-",Sys.Date(),".csv",sep=""),sep=",")
# Quits R
#quit(save="no")
#################################################################################################################