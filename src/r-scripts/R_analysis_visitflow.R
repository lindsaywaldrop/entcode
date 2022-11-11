#################################################################################################################
#################################################################################################################
###
### Visit Flow Field Calculations
###
#################################################################################################################


#### Function definitions ####
source("./src/r-scripts/datahandling_functions.R")

#### Parameters ####
nohairs <- 3     # Total number of hairs in the array. 
# Options: 3, 5, 7, 12, 18, 25
n <- 2000		  # number of simulations to analyze

# Parameters that should not change
ignore <- 3
run_dir <- paste(nohairs, "hair_runs/", sep = "") # Constructs hair directory
duration <- 0.03   	 	 # duration of simulation, s
dist <- 0.002          # diameter of each hair, m
speed <- 0.06      	 	 # free fluid speed, m/s
sample <- 5000			 # sampling rate
rowno <- findnorows(nohairs)

#### Sets up directories ####
mainDir1 <- "./results/r-csv-files"
subDir1 <- paste(nohairs, "hair_results", sep = "")
dir.create(file.path(mainDir1, subDir1), showWarnings = FALSE)

#### Loading parameter file ####
parameters <- load_parameters()

#### Pre-allocating space ####
shear_hair <- matrix(data = NA, nrow = nrow(parameters), ncol = nohairs)	# Allocates space for shear calculations
flux <- matrix(data = NA, nrow = nrow(parameters), ncol = nohairs)	# Allocates space for shear calculations
Umean <- matrix(data = NA, nrow = nrow(parameters), ncol = nohairs)
leakiness <- matrix(data = NA, nrow = nrow(parameters), ncol = rowno)	# Allocates space for leakiness calculation

colnames(shear_hair) <- create_hair_names(nohairs, "shear")
colnames(flux) <- create_hair_names(nohairs, "flux")
colnames(Umean) <- create_hair_names(nohairs, "Umean")
colnames(leakiness) <- create_hair_names(rowno, "leakiness")

#### Main Loop for Calculations ####
for (j in 1:n){		# Main loop over simulations
  print(paste("Simulation: ", j, sep = ""))		# Prints simulation number 
  shear_hair[j, ] <- calculate_maxshear(nohairs, ignore, j) 
  flux[j, ] <-calculate_flux(nohairs, run_dir, dist, j)
  Umean[j, ] <- calculate_Umean(nohairs, j)
  leakiness[j, ] <- calculate_leakiness(rowno, run_dir, speed, sample, j)
}

#### Checking data sets for completeness and saving ####
all_numbers <- cbind(shear_hair, flux, Umean, leakiness)
all_numbers2 <- check_completeness_save(parameters, all_numbers, nohairs, "flowdata")

#################################################################################################################