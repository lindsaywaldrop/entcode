#################################################################################################################
#################################################################################################################
###
### Shear Calculations
###
#################################################################################################################

#### Assign condition values ####
norows <- 5              # Total number of rows in the array. Options: "3", "4"
nohairs <- 25            # Total number of hairs in the array. Options: "12", "18"
rundir <- paste(nohairs, "hair_runs/", sep = "")   # Runs directory. Options: "runs_3row/", "runs/"
n <- 165				         # number of simulations to analyze

# The following vector dictates which side the shear should be sampled on. 
# The hair where sampling started (e.g. hair 3 for row 1) should be "-1".
# The hair where sampling ended (e.g. hair 2 for row 1) should be "1".
# All interior hairs should be "0".
whichside<-c( 0,  1, -1,         # row 1
              0,  0,  1, -1,       # row 2
             -1,  0,  0,  0,  1,     # row 3
             -1,  0,  0,  0,  0,  1,   # row 4
             -1,  0,  0,  0,  0,  0,  1) # row 5

hair_dia <- 0.002   	 	 # diameter of each hair, m
sample <- 5000			     # sampling rate
shear_hair < -matrix(data = 0, nrow = n, ncol = nohairs)	# Allocates space for shear calculations

#### Main Loop for Calculations ####
for (j in 1:n){		# Main loop
  print(paste("Simulation: ", j, sep = ""))					# Prints simulation number 
  
  for (arrayrow in 1:norows){
    dirname2 <- paste("./results/visit/", rundir, "sim", j, "/hairline", 
                      arrayrow, "/", sep = "") # Construct directory name
    data1 <- read.table(paste(dirname2, "hairline0003.curve", sep = ""), 
                        header = FALSE, sep = "")	# Loads final time-step data
    rowwidth <- data1$V1[sample + 1] - data1$V1[1] # Calculates real width of sampled region
    samplewidth <- rowwidth / sample # Calculates real width between sample points
    half_hair_width <- floor((0.5) * hair_dia / samplewidth) # Calculates number of sample points covered by hair radius
    shear_point <- floor((1) * hair_dia / samplewidth) # Calculates number of sample points covered by hair diameter
    
    if (arrayrow==1){ # Assigning which hairs to run calculation
      hairsinrow <- 3    # Sets the number of hairs in the current rwo
      hairsdone <- 0     # Sets the hairs already calculated based on current row
    }else if (arrayrow==2){
      hairsinrow <- 4
      hairsdone <- 3
    }else if (arrayrow==3){
      hairsinrow <- 5
      hairsdone <- 7
    }else if (arrayrow==4){
      hairsinrow <- 6
      hairsdone <- 12
    }else{ 
      hairsinrow <- 7
      hairsdone <- 18
    }
    
    for (k in 1:hairsinrow){  
      side <- whichside[k + hairsdone] # Assigns which side the shear calculation should be on
      if (side==-1){  # Sets start and end points of calculation based on which side 
        stpt <- half_hair_width
        endpt <- half_hair_width + shear_point
      }else {
        stpt <- (length(data1$V1) - (half_hair_width + shear_point))
        endpt <- (length(data1$V1) - half_hair_width)
      }
      curve < -smooth.spline(data1$V1[stpt:endpt], data1$V2[stpt:endpt], spar = 0.90) # Creates smooth spline fit of data
      new.curve <- predict(curve, seq(min(data1$V1[stpt:endpt]), max(data1$V1[stpt:endpt]),
                                    by = 0.00005)) # Resamples to create smooth spline curve
      slopes <- diff(new.curve$y) / diff(new.curve$x)  # Calculates slopes between points of smooth spline
      shear_hair[j, k + hairsdone] <- abs(mean(slopes, na.rm = TRUE)) # Calculates mean shear rate of all points in smooth spline
    } # ends hairs in row loop
  } # ends array row loop
} # ends main loop

#### Final Data Processing and Saving ####
shear_hair2 <- data.frame(shear_hair)  # Turns matrix into data frame
shearnames <- as.character(rep(0, nohairs)) # Allocates space for names 
for (i in 1:nohairs) shearnames[i] <- paste("hair", i, sep = "") # Assigns name for each hair
names(shear_hair2) <- shearnames # Assigns all names to data frame

# Save data!
write.table(shear_hair2, file=paste("./results/r-csv-files/", nohairs, 
                                   "hair_results/shearhairs-", n, "-", Sys.Date(), 
                                   ".csv", sep = ""),
            sep = ",")
# Quits R
#quit(save="no")
#################################################################################################################


