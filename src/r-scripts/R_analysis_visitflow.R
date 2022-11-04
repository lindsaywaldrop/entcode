#################################################################################################################
#################################################################################################################
###
### Single-hair Calculations
###
#################################################################################################################

#### Parameters ####
nohairs <- 3     # Total number of hairs in the array. 
# Options: 3, 5, 7, 12, 18, 25
n <- 1		  # number of simulations to analyze

# Parameters that should not change
ignore <- 3
run_dir <- paste(nohairs, "hair_runs/", sep = "") # Constructs hair directory
duration <- 0.03   	 	 # duration of simulation, s
dist <- 0.002          # diameter of each hair, m
speed <- 0.06      	 	 # free fluid speed, m/s
sample <- 5000			 # sampling rate

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

#### Sets up directories ####
mainDir1 <- "./results/r-csv-files"
subDir1 <- paste(nohairs, "hair_results", sep = "")
dir.create(file.path(mainDir1, subDir1), showWarnings = FALSE)


# Loading parameter file
parameters <- read.table(paste("./data/parameters/data_uniform_2000.txt", sep = ""), 
                         sep = "\t")
parameter_names <- c("angle", "gap", "ant", "dist", "re", "diff_coef", "stink_width", "init_conc")
names(parameters) <- parameter_names

#### Function definitions ####
source("./src/r-scripts/analysis_functions.R")

#### Pre-allocating space ####
shear_hair <- matrix(data = NA, nrow = nrow(parameters), ncol = nohairs)	# Allocates space for shear calculations
flux <- matrix(data = NA, nrow = nrow(parameters), ncol = nohairs)	# Allocates space for shear calculations
Umean <- matrix(data = NA, nrow = nrow(parameters), ncol = nohairs)
leakiness <- matrix(data = NA, nrow = nrow(parameters), ncol = rowno)	# Allocates space for leakiness calculation

#### Main Loop for Calculations ####
for (j in 1:n){		# Main loop over simulations
  print(paste("Simulation: ", j, sep = ""))		# Prints simulation number 
  shear_hair[j,] <- calculate_maxshear(nohairs, ignore, j) 
  flux[j,] <-calculate_flux(nohairs, run_dir, dist, j)
  Umean[j,] <- calculate_Umean(nohairs, j)
  leakiness[j,] <- calculate_leakiness(rowno, run_dir, speed, sample, j)
}


#### Checking data sets for completeness and saving ####
shear2 <- check_completeness_save(parameters, shear_hair, nohairs, "shear")
flux2 <- check_completeness_save(parameters, flux, nohairs, "flux")
Umean2 <- check_completeness_save(parameters, Umean, nohairs, "Umean")
leakiness2 <- check_completeness_save(parameters, leakiness, rowno, "leakiness")

#################################################################################################################


