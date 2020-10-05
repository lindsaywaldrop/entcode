#################################################################################################################
#################################################################################################################
###
### Volume flow rate Calculations
###
#################################################################################################################

nohairs <- 25     # Total number of hairs in the array. 
# Options: "3", "5", "7", "12", "18", "25"
n <- 83				  # number of simulations to analyze

Umean<-matrix(data=0,nrow=n,ncol=nohairs)

for (j in 1:n){		# Main loop over simulations
	print(paste("Simulation: ",j,sep=""))					# Prints simulation number 
	for (i in 1:nohairs){
		# Loads Umean data
		data <- read.table(paste("./results/visit/", nohairs, "hair_runs/sim", j, 
		                         "/Umean/Umag_hair", i, ".curve", sep = ""), 
		                   header = FALSE, sep = " ")	
		k<-as.numeric(length(data$V2))
		Umean[j,i]=data$V2[k]
		}
}

# Sets up Umean data as data frame
Umean2 <- data.frame(Umean)  # Turns matrix into data frame
Umeannames <- as.character(rep(0, nohairs)) # Allocates space for names 
for (i in 1:nohairs) Umeannames[i] <- paste("hair", i, sep = "") # Assigns name for each hair
names(Umean2) <- Umeannames # Assigns all names to data frame

# Saves leakiness values
write.table(Umean2, file = paste("./results/r-csv-files/", nohairs, 
                                 "hair_results/Umean_", n, "_", Sys.Date(), 
                                 ".csv", sep = ""), 
            sep = ",")

