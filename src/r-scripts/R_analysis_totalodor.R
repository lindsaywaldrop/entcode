#################################################################################################################
#################################################################################################################
###
### Total odorant captured calculation
###
#################################################################################################################
source("./src/r-scripts/datahandling_functions.R")

####  Parameters  ####
hairno <- 3  # Total number of hairs in the array. 
# Options: "3", "5", "7", "12", "18", "25"
startn <- 1
n <- 2000				  # number of simulations to analyze
fluid <- "water"  # fluid of simulation, options: air, water

# Loading parameter file
parameters <- load_parameters()
# Assigns total number of rows in the array.
rowno <- findnorows(hairno)

#### Sets up directories ####
mainDir1 <- "./results/r-csv-files"
subDir1 <- paste(hairno,"hair_results",sep="")
dir.create(file.path(mainDir1, subDir1), showWarnings = FALSE)

####  Running analysis  ####

# Pre-allocating space
total.conc <- rep(NA, length = nrow(parameters))
norm.conc <- rep(NA, length = nrow(parameters))
totals.hairs <- matrix(data = NA, nrow = nrow(parameters), ncol = hairno)
totals.rows <- matrix(data = NA, nrow = nrow(parameters), ncol = rowno)

for(i in startn:n){
  run_id <- stringr::str_pad(i, 4, pad = "0")
  
  if(!file.exists(paste("./results/odorcapture/", hairno, "hair_array/", 
                        "hairs_c_", run_id, ".mat", sep = ""))){
    print(paste("Simulation",run_id," not found."))
  }else{
    print(paste("Simulation",run_id))
    hair.conc <- convert_odorconc(run_id, fluid, hairno)
    if(!hair.conc$threshold & run_id == "0531") hair.conc$threshold <- TRUE
    if(!hair.conc$threshold){
      print(paste("Simulation",run_id,"did not finish."))
    } else{
      last.timestep <- length(hair.conc[["conc.data"]][,1])
      # Calculating total concentration captured by the array:
      total.conc[i] <- sum(hair.conc[["conc.data"]][last.timestep,])
      norm.conc[i] <- total.conc[i]/hair.conc$cmax
      for(j in 1:hairno){
        # Calculating totals for each hair:
        totals.hairs[i,j] <- hair.conc[["conc.data"]][last.timestep,j]
        # Calculating totals for each row:
        if(hairno == 5){
          totals.rows[i,1] <- sum(hair.conc[["conc.data"]][last.timestep,1:5])
        }else {
          if(j >= 1 && j < 4) {
            totals.rows[i,1] <- sum(hair.conc[["conc.data"]][last.timestep,1:3])
            
          }else if(j >= 4 && j < 8) {
            totals.rows[i,2] <- sum(hair.conc[["conc.data"]][last.timestep,4:7])
          }else if(j >= 8 && j < 13){
            totals.rows[i,3] <- sum(hair.conc[["conc.data"]][last.timestep,8:12])
          }else if(j >= 13 && j < 19){
            totals.rows[i, 4] <- sum(hair.conc[["conc.data"]][last.timestep, 13:18])
          }else if(j >= 19 && j <= 25){
            totals.rows[i, 5] <- sum(hair.conc[["conc.data"]][last.timestep, 19:25])
          } else {
            message("?? Unknown hair number")
          }
        } #hairno else end
      } #for loop end
    } # threshold else end
    if(i==n) col_hair_names <- colnames(hair.conc[["hairs.positions"]])
    rm(hair.conc)
  } #main else end
}

# Constructing final data frame
colnames(totals.hairs) <- col_hair_names
leaknames <- as.character(rep(0, rowno)) # Allocates space for names 
for (i in 1:rowno) leaknames[i] <- paste("row", i, sep = "") # Assigns name for each hair
colnames(totals.rows) <- leaknames
#norm.conc <- total.conc/parameters$init_conc
conctotals <- data.frame(parameters, total.conc, norm.conc, totals.hairs, totals.rows)

#### Checking and Saving Data ####
check_completeness_save(parameters, conctotals, hairno, filename_base = "totalconc")
