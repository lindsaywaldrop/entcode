#################################################################################################################
#################################################################################################################
###
### Total odorant captured calculation
###
#################################################################################################################
library(parallel)
library(doParallel)
library(foreach)

source("./src/r-scripts/datahandling_functions.R")

cores <- detectCores()
cluster <- register_backend(cores, F)

####  Parameters  ####
today_date <- "2023-11-02"
hairno <- 25  # Total number of hairs in the array. 
# Options: "3", "5", "7", "12", "18", "25"
startn <- 1
n <- 	2 		  # number of simulations to analyze
fluid <- "water"  # fluid of simulation, options: air, water

# Loading parameter file
parameters <- load_parameters()
# Assigns total number of rows in the array.
rowno <- findnorows(hairno)

#### Sets up directories ####
mainDir1 <- "./results/r-csv-files"
mainDir2 <- "/Volumes/Isengard/entcode/results/odorcapture"
subDir1 <- paste(hairno, "hair_results", sep = "")
dir.create(file.path(mainDir1, subDir1), showWarnings = FALSE)
filename <- paste0("totalconc_", hairno, "hairs_", today_date)


# Pre-allocating space
raw_total_conc <- rep(NA, length = nrow(parameters))
total_conc <- rep(NA, length = nrow(parameters))
norm_conc <- rep(NA, length = nrow(parameters))
totals_hairs <- matrix(data = NA, nrow = nrow(parameters), ncol = hairno)
totals_rows <- matrix(data = NA, nrow = nrow(parameters), ncol = rowno)
cmax <- rep(NA, length = nrow(parameters))
ctotal <- rep(NA, length = nrow(parameters))
domain_area <- rep(NA, length = nrow(parameters))
dat_cols <- sum(1, ncol(parameters), 1, 1, hairno, rowno)
hair_dots <- rep(NA, nrow(parameters))
hair_dxdy <- rep(NA, nrow(parameters))

if(file.exists(file.path(mainDir1, subDir1, paste0(filename, ".csv")))) {
  message("This file already exists, and will be added to!!")  
} else {
  cat(as.character(paste0("Total Odor Concentration -- Started on ", today_date)), 
      sep = "\n", 
      file = paste0(mainDir1, "/", subDir1, "/",filename, ".csv"), 
      append = FALSE)
  hair_conc <- convert_odorconc("0001", fluid, hairno, mainDir2)
  col_hair_names <- colnames(hair_conc[["hairs.positions"]])
  colnames(totals_hairs) <- col_hair_names
  leaknames <- as.character(rep(0, rowno)) # Allocates space for names 
  for (i in 1:rowno) leaknames[i] <- paste("row", i, sep = "") # Assigns name for each hair
  colnames(totals_rows) <- leaknames
  cat(as.character(paste("simulation_number", paste(colnames(parameters), collapse = ","), 
                         "hair_dots","hair_dxdy","domain_area","cmax","ctotal",
                         "raw_total_conc", "total_conc", "norm_conc", 
                         paste(colnames(totals_hairs), collapse = ","), 
                         paste(colnames(totals_rows), collapse = ","),
                         sep = ",")),
      sep = "\n", 
      file = paste0(mainDir1, "/", subDir1, "/",filename, ".csv"),
      append = TRUE)
}


####  Running analysis  ####

foreach(i = startn:n) %dopar% {
#for(i in startn:n){
  run_id <- stringr::str_pad(i, 4, pad = "0")
  
  if(!file.exists(paste(mainDir2, "/", hairno, "hair_array/", 
                        "hairs_c_", run_id, ".mat", sep = ""))){
    print(paste("Simulation", run_id," not found."))
  }else{
    print(paste("Simulation",run_id))
    hair_conc <- convert_odorconc(run_id, fluid, hairno, mainDir2)
    if(run_id == "0531" | run_id == "0866") hair_conc$threshold <- TRUE
    if(!hair_conc$threshold){
      print(paste("Simulation", run_id, "did not finish."))
    } else{
      last_timestep <- length(hair_conc[["conc.data"]][ , 1])
      # Calculating total concentration captured by the array:
      raw_total_conc[i] <- sum(hair_conc[["conc.data"]][last_timestep, ])
      hair_dots[i] <- sum(hair_conc$hairdots)
      hair_dxdy[i] <- hair_conc$dx * hair_conc$dy
      total_conc[i] <- raw_total_conc[i] / (hair_dxdy[i] * hair_dots[i])
      norm_conc[i] <- total_conc[i] / hair_conc$cmax
      
      cmax[i] <- hair_conc$cmax
      ctotal[i] <- hair_conc$ctotal
      domain_area[i] <- hair_conc$xlength * hair_conc$ylength
      for(j in 1:hairno){
        # Calculating totals for each hair:
        totals_hairs[i, j] <- hair_conc[["conc.data"]][last_timestep, j]
        # Calculating totals for each row:
        if(hairno == 5){
          totals_rows[i, 1] <- sum(hair_conc[["conc.data"]][last_timestep, 1:5])
        }else {
          if(j >= 1 && j < 4) {
            totals_rows[i, 1] <- sum(hair_conc[["conc.data"]][last_timestep, 1:3])
            
          }else if(j >= 4 && j < 8) {
            totals_rows[i, 2] <- sum(hair_conc[["conc.data"]][last_timestep, 4:7])
          }else if(j >= 8 && j < 13){
            totals_rows[i, 3] <- sum(hair_conc[["conc.data"]][last_timestep, 8:12])
          }else if(j >= 13 && j < 19){
            totals_rows[i, 4] <- sum(hair_conc[["conc.data"]][last_timestep, 13:18])
          }else if(j >= 19 && j <= 25){
            totals_rows[i, 5] <- sum(hair_conc[["conc.data"]][last_timestep, 19:25])
          } else {
            message("?? Unknown hair number")
          }
        } #hairno else end
      } #for hairno loop end
      cat(as.character(paste(i, 
                             paste(parameters[i, ], collapse = ","), 
                             hair_dots[i],
                             hair_dxdy[i],
                             domain_area[i],
                             cmax[i],
                             ctotal[i],
                             raw_total_conc[i],
                             total_conc[i], 
                             norm_conc[i], 
                             paste(totals_hairs[i, ], collapse = ","), 
                             paste(totals_rows[i, ], collapse = ","),
                             sep = ",")),
          sep = "\n", 
          file = paste0(mainDir1, "/", subDir1, "/", filename, ".csv"),
          append = TRUE)
    } # threshold else end
  } #main else end
}

# Loading the data set
dat <- read.csv(file = paste0(mainDir1, "/", subDir1, "/", filename, ".csv"), skip = 1)


#### Checking Data ####
out_check <- check_completeness(dat, parameters)
if(!is.null(out_check) & is.data.frame(out_check)){
  write.csv(out_check, file = paste0(mainDir1, "/", subDir1, "/", filename, "_cleaned.csv"))
}

