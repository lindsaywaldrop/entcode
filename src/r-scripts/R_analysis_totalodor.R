#################################################################################################################
#################################################################################################################
###
### Total odorant captured calculation
###
#################################################################################################################
# Libraries
library(R.matlab)
library(stringr)
library(data.table)

####  Parameters  ####
hairno <- 18  # Total number of hairs in the array. 
# Options: "3", "5", "7", "12", "18", "25"
n <- 165				  # number of simulations to analyze
fluid <- "water"  # fluid of simulation, options: air, water

####  Function Definitions  ####
convert_odorconc <- function(run_id,fluid,hairno) {
  require(R.matlab)
  data<-readMat(paste("./results/odorcapture/",hairno,"hair_array/",fluid,"/hairs_c_",run_id,".mat", sep = ""))
  steps.number <- length(data) - 2
  hairs.number <- length(data$hairs.center[, 1])
  conc.data <- matrix(NA, ncol = hairs.number, nrow = steps.number)
  colnames(conc.data) <- paste("h", as.character(1:hairs.number), sep = "")
  rownames(conc.data) <- as.character(1:steps.number)
  hairs.positions <- t(data$hairs.center)
  colnames(hairs.positions) <- paste("h", as.character(1:hairs.number), sep = "")
  rownames(hairs.positions) <- c("x", "y")
  for (i in 1:steps.number){
    for (j in 1:hairs.number){
      a <- data[[paste("hairs.c.", i, sep = "")]][[j]][[1]]
      if (length(a)==0) { conc.data[i,j] <- 0 }
      else {conc.data[i,j] <- sum(data[[paste("hairs.c.", i, sep = "")]][[j]][[1]])}
    }
  }
  extracted<-list(hairs.positions=hairs.positions,conc.data=conc.data)
  return(extracted)
}

####  Running analysis  ####

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
        totals.rows[i,4] <- sum(hair.conc[["conc.data"]][last.timestep,13:18])
      }else if(j >= 19 && j <= 25){
        totals.rows[i,5] <- sum(hair.conc[["conc.data"]][last.timestep,19:25])
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
conctotals<-data.frame(total.conc,totals.hairs,totals.rows)

#### Checking and Saving Data ####
complete<-as.numeric(sum(is.na(conctotals)))
message("~.*^*~Completeness check~*^*~.~\n",
        "Number of NAs: ",complete)
if (complete==0){
  message("Set complete. Saving now!")
  write.table(conctotals, file = paste("./results/r-csv-files/", hairno, 
                                   "hair_results/totalconc_", n, "_", Sys.Date(), 
                                   ".csv", sep = ""), 
              sep = ",")
} else {
  message("Set not complete, did not save")
}
