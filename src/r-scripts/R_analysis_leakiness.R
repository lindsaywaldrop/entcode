#################################################################################################################
#################################################################################################################
###
### Leakiness Calculations
###
#################################################################################################################

nohairs <- 3     # Total number of hairs in the array. 
# Options: "3", "5", "7", "12", "18", "25"
n <- 2				  # number of simulations to analyze

# Loading parameter file
parameters <- read.table(paste("./data/parameters/data_uniform_2000.txt", sep = ""), sep = "\t")
parameter_names <- c("angle", "gap", "ant", "dist", "re", "diff_coef", "stink_width", "init_conc")
names(parameters) <- parameter_names

# Assigns total number of rows in the array.
if(nohairs == 25){ 
  rowno <- 5
}else if (nohairs == 18){
  rowno <- 4
}else if(nohairs == 12){
  rowno <- 3
}else if (nohairs == 7){
  rowno <- 2
}else {
  rowno <- 1
}

# Other parameters that should not change
rundir <- paste(nohairs, "hair_runs/", sep = "")   # Constructs hair directory
speed <- 0.06      	 	 # free fluid speed, m/s
sample <- 5000			 # sampling rate
leakiness <- matrix(data = NA, nrow = nrow(parameters), ncol = rowno)	# Allocates space for leakiness calculation

#### Main Loop for Calculations ####
for (j in 1:n){		# Main loop over simulations
	print(paste("Simulation: ", j, sep = ""))					# Prints simulation number 
  for (arrayrow in 1:rowno){ # Loop over rows 
    dirname2 <- paste("./results/visit/", rundir, "sim", j, "/hairline", 
                      arrayrow, "/", sep = "") # Construct directory name
    data1 <- read.table(paste(dirname2, "hairline0003.curve", sep = ""), 
                        header = FALSE, sep = "")	# Loads final time-step data
	  rowwidth <- data1$V1[sample + 1] - data1$V1[1]
	  samplewidth <- rowwidth / sample # Calculates real width between sample points
	  leak_bot <- (speed) * rowwidth	# Calculates bottom of leakiness ratio
	  data2 <- rep(0, length(data1$V1))		# Allocates space for leakiness calculation
	  
	  for (i in 1:sample+1){	# Loop that cycles through each sampled point in a simulation
	    data2[i] <- (data1$V2[i] * samplewidth)	# Calculates top of leakiness for each sampled point
	  }
	  leakiness[j, arrayrow] <- sum(data2) / leak_bot	# Calculates leakiness value for each simulation
	  rm(data2)
  } # End loop over rows
} # End main loop

#plot(leakiness,ylim=c(0,1))		# Plots final values of leakiness for each simulation

# Sets up leakiness values in data frame
leakiness2 <- data.frame(parameters, leakiness)
leaknames <- as.character(rep(0, rowno)) # Allocates space for names 
for (i in 1:rowno) leaknames[i] <- paste("row", i, sep = "") # Assigns name for each hair
names(leakiness2) <- c(parameter_names, leaknames) # Assigns all names to data frame

#### Checking and Saving Data ####
complete <- as.numeric(sum(is.na(leakiness2)))
message("~.*^*~Completeness check~*^*~.~\n",
        "Number of NAs: ",complete)
if (complete == 0){
  message("Set complete. Saving now!")
  write.table(leakiness2, file = 
                 paste("./results/r-csv-files/", nohairs, "hair_results/leakiness_", 
                    n, "_", Sys.Date(), ".csv", sep = ""),
            sep = ",", row.names = FALSE)
} else {
  message("Set not complete, did not save")
}
# Quits R
#quit(save="no")
#################################################################################################################