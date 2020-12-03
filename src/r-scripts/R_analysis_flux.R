#################################################################################################################
#################################################################################################################
###
### Volume Flux Calculations
###
#################################################################################################################

#### Parameters ####
nohairs <- 25     # Total number of hairs in the array. 
                  # Options: "3", "5", "7", "12", "18", "25"
n <- 165				    # Total number of simulations to analyze

# Parameters that should not change
rundir <- paste(nohairs, "hair_runs/", sep = "") # Constructs hair directory
duration <- 0.03   	 	 # duration of simulation, s
dist <- 0.002          # diameter of each hair, m

# Loading parameter file
parameters <- read.table(paste("./data/parameters/allpara_", n, ".txt", sep = ""), sep = "\t")
parameter_names <- c("angle", "gap", "Re")
# Allocating space
flux <- matrix(data = NA, nrow = n, ncol = nohairs)
norm <- data.frame(x = c(1, 0, -1, 0), y = c(0, -1, 0, 1))

for (j in 1:n){		# Main loop over simulations
	print(paste("Simulation: ",j,sep=""))					# Prints simulation number 
  dirname <- paste("./results/visit/", rundir, "sim", j, "/hairline_flux/", 
                    sep = "") # Construct directory name
  
	for (i in 1:nohairs){ # Loop over individual hairs to calculate flux
	  for (k in 0:3){
	    # Reads in square side velocity components Ux and Uy
	    # Sides: 0 - Top right to bottom right; 1 - Bottom right to bottom left; 
	    #        2 - Bottom left to top left;   3 - Top left to top right
		  Ux <- read.table(paste(dirname, "flux_hair", i, 
		                         "_Ux_side", k, ".curve", sep=""), header = FALSE, sep = "")	
		  Uy <- read.table(paste(dirname, "flux_hair", i, 
		                         "_Uy_side", k, ".curve", sep=""), header = FALSE, sep = "")	
		  assign(paste("Ux.side", k, sep = ""), Ux)
		  assign(paste("Uy.side", k, sep = ""), Uy)
	  }
	  # Calculates flux
	  flux[j,i] <- sum(sum(Ux.side0$V2 * norm$x[1]) + sum(Uy.side0$V2 * norm$y[1]),
	                   sum(Ux.side1$V2 * norm$x[2]) + sum(Uy.side0$V2 * norm$y[2]),
	                   sum(Ux.side2$V2 * norm$x[3]) + sum(Uy.side2$V2 * norm$y[3]), 
	                   sum(Ux.side3$V2 * norm$x[4]) + sum(Uy.side3$V2 * norm$y[4])) * (2 * 4 * dist)
	  # Removes variables
	  rm(Ux,Uy,Ux.side0,Uy.side0,Ux.side1,Uy.side1,Ux.side2,Uy.side2,Ux.side3,Uy.side3)
	} # End loop over hairs
} # End main loop

# Sets up flux in data frame
fluxnames <- as.character(rep(0, nohairs)) # Allocates space for names 
for (i in 1:nohairs) fluxnames[i] <- paste("hair", i, sep = "") # Assigns name for each hair
flux2 <- data.frame(parameters, flux)
names(flux2) <- c(parameter_names, fluxnames)

#### Checking and Saving Data ####
complete<-as.numeric(sum(is.na(flux2)))
message("~.*^*~Completeness check~*^*~.~\n",
        "Number of NAs: ",complete)
if (complete==0){
  message("Set complete. Saving now!")
  write.table(flux2, file = paste("./results/r-csv-files/", nohairs, "hair_results/flux_", n,
                                "_", Sys.Date(), ".csv", sep = ""), sep = ",", row.names = FALSE)
} else {
  message("Set not complete, did not save")
}
