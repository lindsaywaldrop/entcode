#################################################################################################################
#################################################################################################################
###
### Shear Calculations
###
#################################################################################################################

#### Parameters ####
nohairs <- 25     # Total number of hairs in the array. 
# Options: "3", "5", "7", "12", "18", "25"
n <- 165				  # number of simulations to analyze

# Parameters that should not change
ignore <- 3

#### Sets up directories ####
mainDir1 <- "./results/r-csv-files"
subDir1 <- paste(nohairs,"hair_results",sep="")
dir.create(file.path(mainDir1, subDir1), showWarnings = FALSE)

# Allocates space
shear_hair <- matrix(data = NA, nrow = n, ncol = nohairs)	# Allocates space for shear calculations

# Loading parameter file
parameters <- read.table(paste("./data/parameters/allpara_", n, ".txt", sep = ""), sep = "\t")
parameter_names <- c("angle", "gap", "Re")

#### Function definitions ####

calculatemaxshear <- function(data,ignore){
  len <- length(data[,1])
  shear <- matrix(NA, nrow = (len-1), ncol = 2)
  shear[,1] <- data[2:len,1]
  for(ii in 2:(length(data[,1]-1))){
    shear[ii-1,2] <- (data[ii,2]-data[ii-1,2])/(data[ii,1]-data[ii-1,1])
  }
  shear <- shear[ignore:len-1,]
  return(max(abs(shear[,2])))
}


#### Main Loop for Calculations ####
for (j in 1:n){		# Main loop over simulations
  print(paste("Simulation: ", j, sep = ""))		# Prints simulation number 
  for (hair in 1:nohairs){
  shear.data <-read.table(paste("./results/visit/",nohairs,"hair_runs/sim",j,
                                "/shear/shear_hair",hair,".curve", sep = ""), 
                          header=FALSE, skip = 1)
   shear_hair[j,hair] <- calculatemaxshear(shear.data,ignore) 
  }
}

#### Final Data Processing and Saving ####
shear_hair2 <- data.frame(parameters, shear_hair)  # Turns matrix into data frame
shearnames <- as.character(rep(0, nohairs)) # Allocates space for names 
for (i in 1:nohairs) shearnames[i] <- paste("hair", i, sep = "") # Assigns name for each hair
names(shear_hair2) <- c(parameter_names, shearnames) # Assigns all names to data frame

#### Checking and Saving Data ####
complete<-as.numeric(sum(is.na(shear_hair2)))
message("~.*^*~Completeness check~*^*~.~\n",
        "Number of NAs: ",complete)
if (complete==0){
  message("Set complete. Saving now!")
  write.table(shear_hair2, file=paste("./results/r-csv-files/", nohairs, 
                                   "hair_results/shearhairs_", n, "_", Sys.Date(), 
                                   ".csv", sep = ""),
            sep = ",", row.names = FALSE)
} else {
  message("Set not complete, did not save")
}

#################################################################################################################


