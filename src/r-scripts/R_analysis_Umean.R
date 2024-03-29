#################################################################################################################
#################################################################################################################
###
### Volume flow rate Calculations
###
#################################################################################################################

#### Parameters ####
nohairs <- 3     # Total number of hairs in the array. 
# Options: "3", "5", "7", "12", "18", "25"
n <- 165				  # number of simulations to analyze

#### Sets up directories ####
mainDir1 <- "./results/r-csv-files"
subDir1 <- paste(nohairs,"hair_results",sep="")
dir.create(file.path(mainDir1, subDir1), showWarnings = FALSE)

# Loading parameter file
parameters <- read.table(paste("./data/parameters/allpara_", n, ".txt", sep = ""), sep = "\t")
parameter_names <- c("angle", "gap", "Re")

# Allocates space
Umean<-matrix(data=NA,nrow=n,ncol=nohairs)

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
Umean2 <- data.frame(parameters, Umean)  # Turns matrix into data frame
Umeannames <- as.character(rep(0, nohairs)) # Allocates space for names 
for (i in 1:nohairs) Umeannames[i] <- paste("hair", i, sep = "") # Assigns name for each hair
names(Umean2) <- c(parameter_names, Umeannames) # Assigns all names to data frame

#### Checking and Saving Data ####
complete<-as.numeric(sum(is.na(Umean2)))
message("~.*^*~Completeness check~*^*~.~\n",
        "Number of NAs: ",complete)
if (complete==0){
  message("Set complete. Saving now!")
  write.table(Umean2, file = paste("./results/r-csv-files/", nohairs, 
                                 "hair_results/Umean_", n, "_", Sys.Date(), 
                                 ".csv", sep = ""), 
            sep = ",", row.names = FALSE)
} else {
  message("Set not complete, did not save")
}
