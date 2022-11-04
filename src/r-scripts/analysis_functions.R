#### R Analysis Functions ####

calculate_maxshear <- function(nohairs, ignore, sim_no){
  shear_hair <- rep(NA, nohairs)
  for (hair in 1:nohairs){
    data <-read.table(paste("./results/visit/", nohairs, "hair_runs/sim", sim_no,
                                  "/shear/shear_hair", hair, ".curve", sep = ""), 
                            header = FALSE, skip = 1)
    len <- length(data[, 1])
    shear <- matrix(NA, nrow = (len - 1), ncol = 2)
    shear[, 1] <- data[2:len, 1]
    for(ii in 2:(length(data[, 1] - 1))){
      shear[ii - 1, 2] <- (data[ii, 2] - data[ii - 1, 2])/(data[ii, 1] - data[ii - 1, 1])
    }
    shear <- shear[ignore:len - 1,]
    shear_hair[hair] <- max(abs(shear[, 2]))
  }
  return(shear_hair)
}

calculate_flux <- function(nohairs, run_dir, dist, sim_num) {
  dir_name <- paste("./results/visit/", run_dir, "sim", sim_num, "/hairline_flux/", 
                     sep = "") # Construct directory name
  flux <- rep(NA, nohairs)
  blep <- data.frame(x = c(1,0,-1,0), y = c(0,-1,0,1))
  for (hair in 1:nohairs){ # Loop over individual hairs to calculate flux
    for (k in 0:3){
      # Reads in square side velocity components Ux and Uy
      # Sides: 0 - Top right to bottom right; 1 - Bottom right to bottom left; 
      #        2 - Bottom left to top left;   3 - Top left to top right
      Ux <- read.table(paste(dir_name, "flux_hair", hair, 
                             "_Ux_side", k, ".curve", sep=""), header = FALSE, sep = "")	
      Uy <- read.table(paste(dir_name, "flux_hair", hair, 
                             "_Uy_side", k, ".curve", sep=""), header = FALSE, sep = "")	
      assign(paste("Ux.side", k, sep = ""), Ux)
      assign(paste("Uy.side", k, sep = ""), Uy)
    }
    # Calculates flux
    flux[hair] <- sum(sum(Ux.side0$V2 * blep$x[1]) + sum(Uy.side0$V2 * blep$y[1]),
                     sum(Ux.side1$V2 * blep$x[2]) + sum(Uy.side0$V2 * blep$y[2]),
                     sum(Ux.side2$V2 * blep$x[3]) + sum(Uy.side2$V2 * blep$y[3]), 
                     sum(Ux.side3$V2 * blep$x[4]) + sum(Uy.side3$V2 * blep$y[4])) * (2 * 4 * dist)
    # Removes variables
    rm(Ux, Uy, Ux.side0, Uy.side0, Ux.side1, Uy.side1, Ux.side2, Uy.side2, 
       Ux.side3, Uy.side3)
  } # End loop over hairs
  return(flux)
}

calculate_Umean <- function(nohairs, sim_no){
  Umean <- rep(NA, nohairs)
  for (j in 1:nohairs){
    # Loads Umean data
    dat <- read.table(paste("./results/visit/", nohairs, "hair_runs/sim", sim_no, 
                             "/Umean/Umag_hair", j, ".curve", sep = ""), 
                       header = FALSE, sep = " ")	
    k <- as.numeric(length(dat$V2))
    Umean[j] <- dat$V2[k]
  }
  return(Umean)
}

check_completeness_save <- function(parameters, dat, nohairs, filename_base){
  # Sets up Umean data as data frame
  parameter_names <- names(parameters)
  dat2 <- data.frame(parameters, dat)  # Turns matrix into data frame
  Hair_names <- as.character(rep(0, nohairs)) # Allocates space for names 
  for (i in 1:nohairs) Hair_names[i] <- paste(filename_base, "hair", i, sep = "_") # Assigns name for each hair
  names(dat2) <- c(parameter_names, Hair_names) # Assigns all names to data frame
  
  #### Checking and Saving Data ####
  complete <- as.numeric(sum(is.na(dat2)))
  message("~.*^*~Completeness check~*^*~.~\n",
          "Number of NAs: ", complete)
  if (complete == 0){
    message("Set complete. Saving now!")
    write.table(dat2, file = paste("./results/r-csv-files/", nohairs, 
                                          "hair_results/",filename_base,"_", Sys.Date(), 
                                          ".csv", sep = ""),
                sep = ",", row.names = FALSE)
  } else {
    message("Set not complete, did not save")
  }
  return(dat2)
}

convert_odorconc <- function(run_id, fluid, hairno) {
  require(R.matlab)
  data <- readMat(paste("./results/odorcapture/", hairno, "hair_array/", fluid, 
                        "/hairs_c_", run_id, ".mat", sep = ""))
  steps.number <- length(data) - 2
  hairs.number <- length(data$hairs.center[, 1])
  conc.data <- matrix(NA, ncol = hairs.number, nrow = steps.number)
  colnames(conc.data) <- paste("hair", as.character(1:hairs.number), sep = "")
  rownames(conc.data) <- as.character(1:steps.number)
  hairs.positions <- t(data$hairs.center)
  colnames(hairs.positions) <- paste("hair", as.character(1:hairs.number), sep = "")
  rownames(hairs.positions) <- c("x", "y")
  for (i in 1:steps.number){
    for (j in 1:hairs.number){
      a <- data[[paste("hairs.c.", i, sep = "")]][[j]][[1]]
      if (length(a) == 0) { conc.data[i, j] <- 0 }
      else {conc.data[i, j] <- sum(data[[paste("hairs.c.", i, sep = "")]][[j]][[1]])}
    }
  }
  extracted <- list(hairs.positions = hairs.positions, conc.data = conc.data)
  return(extracted)
}

magnitude <- function(u, v) {
  it <- sqrt(u^2 + v^2)
  it <- replace(it, is.na(it), 0)
}

convert_ibamr <- function(run_id, fluid,t, hairno) {
  require(R.matlab)
  loc.data <- readMat(paste("./results/odorcapture/", hairno, "hair_array/", fluid, 
                            "/initdata_", run_id, ".mat", sep = ""))
  ibamr.data <- readMat(paste("./results/odorcapture/", hairno, "hair_array/", fluid, 
                              "/velocity_", run_id, ".mat", sep = ""))
  conc.timedata <- readMat(paste("./results/odorcapture/", hairno, "hair_array/", fluid, 
                                 "/c_", run_id, ".mat", sep = ""))
  u <- as.vector(ibamr.data$u.flick)
  v <- as.vector(ibamr.data$v.flick)
  x <- as.vector(matrix(loc.data$x, nrow = nrow(loc.data$x), ncol = nrow(loc.data$y)))
  y <- as.vector(matrix(loc.data$y, nrow = nrow(loc.data$x), ncol = nrow(loc.data$y), 
                        byrow = TRUE))
  c1 <- as.vector(conc.timedata[[t]])
  all.data <- data.frame(x = x, y = y, u = u, v = v, w = magnitude(u, v), c = c1)
  return(all.data)
}
