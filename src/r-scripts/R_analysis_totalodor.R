#################################################################################################################
#################################################################################################################
###
### Total odorant captured calculation
###
#################################################################################################################

source("./src/r-scripts/analysis_functions.R")

####  Parameters  ####
hairno <- 3  # Total number of hairs in the array. 
# Options: "3", "5", "7", "12", "18", "25"
n <- 165				  # number of simulations to analyze
fluid <- "air"  # fluid of simulation, options: air, water



#### Sets up directories ####
mainDir1 <- "./results/r-csv-files"
subDir1 <- paste(nohairs,"hair_results",sep="")
dir.create(file.path(mainDir1, subDir1), showWarnings = FALSE)

####  Function Definitions  ####


####  Running analysis  ####

# Loading parameter file
parameters <- read.table(paste("./data/parameters/allpara_", n, ".txt", sep = ""), sep = "\t")
colnames(parameters) <- c("angle", "gap", "Re")

# Assigns total number of rows in the array.
if(hairno == 25){ 
  rowno <- 5
}else if (hairno == 18){
  rowno <- 4
}else if(hairno == 12){
  rowno <- 3
}else if (hairno == 7){
  rowno <- 2
}else {
  rowno <- 1
}

# Pre-allocating space
total.conc <- NA*vector(length = n)
totals.hairs <- matrix(data = NA, nrow = n, ncol = hairno)
totals.rows <- matrix(data = NA, nrow = n, ncol = rowno)

for(i in 1:n){
  run_id <- str_pad(i, 4, pad = "0")
  print(paste("Simulation",run_id))
  hair.conc <- convert_odorconc(run_id, fluid, hairno)
  last.timestep <- length(hair.conc[["conc.data"]][,1])
  # Calculating total concentration captured by the array:
  total.conc[i] <- sum(hair.conc[["conc.data"]][last.timestep,])
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
    }
  }
}

# Constructing final data frame
colnames(totals.hairs) <- colnames(hair.conc[["hairs.positions"]])
leaknames <- as.character(rep(0, rowno)) # Allocates space for names 
for (i in 1:rowno) leaknames[i] <- paste("row", i, sep = "") # Assigns name for each hair
colnames(totals.rows) <- leaknames
conctotals <- data.frame(parameters, total.conc, totals.hairs, totals.rows)

#### Checking and Saving Data ####
complete <- as.numeric(sum(is.na(conctotals)))
message("~.*^*~Completeness check~*^*~.~\n", 
        "Number of NAs: ", complete)
if (complete == 0){
  message("Set complete. Saving now!")
  write.table(conctotals, file = paste("./results/r-csv-files/", hairno, 
                                   "hair_results/totalconc_", fluid, "_", n, "_", 
                                   Sys.Date(),".csv", sep = ""), 
              sep = ",", row.names = FALSE)
} else {
  message("Set not complete, did not save")
}
