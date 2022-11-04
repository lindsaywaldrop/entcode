
calculate_maxshear <- function(nohairs, ignore, sim_no){
  shear_hair <- rep(NA, nohairs)
  for (hair in 1:nohairs){
    dat <- read.table(paste("./results/visit/", nohairs, "hair_runs/sim", sim_no,
                            "/shear/shear_hair", hair, ".curve", sep = ""), 
                      header = FALSE, skip = 1)
    len <- length(dat[, 1])
    shear <- matrix(NA, nrow = (len - 1), ncol = 2)
    shear[, 1] <- dat[2:len, 1]
    for(ii in 2:(length(dat[, 1] - 1))){
      shear[ii - 1, 2] <- (dat[ii, 2] - dat[ii - 1, 2])/(dat[ii, 1] - dat[ii - 1, 1])
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
  blep <- data.frame(x = c(1, 0, -1, 0), y = c(0, -1, 0, 1))
  for (hair in 1:nohairs){ # Loop over individual hairs to calculate flux
    for (k in 0:3){
      # Reads in square side velocity components Ux and Uy
      # Sides: 0 - Top right to bottom right; 1 - Bottom right to bottom left; 
      #        2 - Bottom left to top left;   3 - Top left to top right
      Ux <- read.table(paste(dir_name, "flux_hair", hair, 
                             "_Ux_side", k, ".curve", sep = ""), header = FALSE, sep = "")	
      Uy <- read.table(paste(dir_name, "flux_hair", hair, 
                             "_Uy_side", k, ".curve", sep = ""), header = FALSE, sep = "")	
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

calculate_leakiness <- function(rowno, run_dir, speed, sample, sim_no){
  leakiness <- rep(NA, rowno)
  for (arrayrow in 1:rowno){ # Loop over rows 
    dirname2 <- paste("./results/visit/", run_dir, "sim", sim_no, "/leakiness", 
                      arrayrow, "/", sep = "") # Construct directory name
    data1 <- read.table(paste(dirname2, "leakiness0003.curve", sep = ""), 
                        header = FALSE, sep = "")	# Loads final time-step data
    rowwidth <- data1$V1[sample + 1] - data1$V1[1]
    samplewidth <- rowwidth / sample # Calculates real width between sample points
    leak_bot <- (speed) * rowwidth	# Calculates bottom of leakiness ratio
    data2 <- rep(0, length(data1$V1))		# Allocates space for leakiness calculation
    for (i in 1:sample+1){	# Loop that cycles through each sampled point in a simulation
      data2[i] <- (data1$V2[i] * samplewidth)	# Calculates top of leakiness for each sampled point
    }
    leakiness[arrayrow] <- sum(data2) / leak_bot	# Calculates leakiness value for each simulation
    rm(data2)
  } # End loop over rows
  return(leakiness)
}

check_completeness_save <- function(parameters, dat, nohairs, filename_base){
  #### Combines parameters and data into data frame ####
  parameter_names <- names(parameters)
  dat2 <- data.frame(parameters, dat)  # Turns matrix into data frame
  Hair_names <- as.character(rep(0, nohairs)) # Allocates space for names 
  if(filename_base=="leakiness"){
    blep <- "row"
  } else {
    blep <- "hair"
  }
  for (i in 1:nohairs) Hair_names[i] <- paste(filename_base, blep, i, sep = "_") # Assigns name for each hair
  names(dat2) <- c(parameter_names, Hair_names) # Assigns all names to data frame
  
  #### Checking and Saving Data ####
  complete <- as.numeric(sum(is.na(dat2)))
  message("~.*^*~Completeness check~*^*~.~\n",
          "Number of NAs: ", complete)
  if (complete == 0){
    message("Set complete. Saving now!")
    write.table(dat2, file = paste("./results/r-csv-files/", nohairs, 
                                   "hair_results/", filename_base, "_", Sys.Date(),
                                   ".csv", sep = ""),
                sep = ",", row.names = FALSE)
  } else {
    message("Set not complete, did not save")
  }
  return(dat2)
}

convert_odorconc <- function(run_id, fluid, hairno) {
  require(R.matlab)
  dat <- readMat(paste("./results/odorcapture/", hairno, "hair_array/", fluid, 
                       "/hairs_c_", run_id, ".mat", sep = ""))
  steps.number <- length(dat) - 2
  hairs.number <- length(dat$hairs.center[, 1])
  conc.data <- matrix(NA, ncol = hairs.number, nrow = steps.number)
  colnames(conc.data) <- paste("hair", as.character(1:hairs.number), sep = "")
  rownames(conc.data) <- as.character(1:steps.number)
  hairs.positions <- t(dat$hairs.center)
  colnames(hairs.positions) <- paste("hair", as.character(1:hairs.number), sep = "")
  rownames(hairs.positions) <- c("x", "y")
  for (i in 1:steps.number){
    for (j in 1:hairs.number){
      a <- dat[[paste("hairs.c.", i, sep = "")]][[j]][[1]]
      if (length(a) == 0) { conc.data[i, j] <- 0 }
      else {conc.data[i, j] <- sum(dat[[paste("hairs.c.", i, sep = "")]][[j]][[1]])}
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


load_parameters <- function(){
  parameters <- read.table(paste("./data/parameters/data_uniform_2000.txt", sep = ""), 
                           sep = "\t")
  parameter_names <- c("angle", "gap", "ant", "dist", "re", "diff_coef", 
                       "stink_width", "init_conc")
  names(parameters) <- parameter_names
  return(parameters)
}

findnorows <- function(nohairs){
  norows <- switch(as.character(nohairs),
                   "3" = 1,
                   "5" = 1,
                   "7" = 2,
                   "12" = 3,
                   "18" = 4,
                   "25" = 5)
  return(norows)
}

reordercols<- function(data,nohairs, datatype){
  parameter.names <- colnames(data[1:3])
  if(datatype == "leakiness"){
    norows <- findnorows(nohairs)
    rownames <- as.character(rep(0, norows))
    for (i in 1:norows) rownames[i] <- paste("row", i, sep = "") 
    new.order <- c(parameter.names, "array", rownames)
  }else if(datatype == "totalconc_water" || datatype == "totalconc_air"){
    norows <- findnorows(nohairs)
    rownames <- as.character(rep(0, norows))
    for (i in 1:norows) rownames[i] <- paste("row", i, sep = "") 
    hairnames <- as.character(rep(0, nohairs)) # Allocates space for names 
    for (i in 1:nohairs) hairnames[i] <- paste("hair", i, sep = "") 
    new.order <- c(parameter.names, "array", "total.conc", hairnames, rownames)
  } else {
    hairnames <- as.character(rep(0, nohairs)) # Allocates space for names 
    for (i in 1:nohairs) hairnames[i] <- paste("hair", i, sep = "") 
    new.order <- c(parameter.names, "array", hairnames)
  }
  newdata <- data[, new.order]
  return(newdata)
}

loadnshapedata<-function(n, datatype, nohairs, date) {
  if (file.exists(paste("../results/r-csv-files/",nohairs,"hair_results/", datatype, "_", n, "_", date, ".csv", sep = ""))){
    data <- read.csv(paste("../results/r-csv-files/",nohairs,"hair_results/", datatype, "_", n, "_", date, ".csv", sep = ""))
  } else {
    data <- read.csv(paste("results/r-csv-files/",nohairs,"hair_results/", datatype, "_", n, "_", date, ".csv", sep = ""))
  }
  
  columns <- colnames(data)
  data2 <- data.frame(data, rep(paste(nohairs, "hair", sep = ""), length = n))
  colnames(data2) <- c(columns, "array")
  data.final <- reordercols(data2,nohairs,datatype)
  return(data.final)
}

stitchdata <- function(n, datatype, data1, data2, nohairs1, nohairs2){
  if(datatype=="leakiness"){
    norows1<-findnorows(nohairs1)
    norows2<-findnorows(nohairs2)
    deltah <- norows2 - norows1
    repnames <- colnames(data1)
    for (i in 1:deltah) {
      data1 <- cbind(data1, rep(NA,length=n))
      repnames <- c(repnames,paste("row",(norows1+i),sep=""))
    }
    colnames(data1)<-repnames
  } else {
    deltah <- nohairs2 - nohairs1
    repnames <- colnames(data1)
    for (i in 1:deltah) {
      data1 <- cbind(data1, rep(NA,length=n))
      repnames <- c(repnames,paste("hair",(nohairs1+i),sep=""))
    }
    colnames(data1)<-repnames
  }
  alldata <- rbind(data1,data2)
  return(alldata)
}

pad.rows<-function(diff.row){
  padding=0
  switch(diff.row,
         "1" = padding<-data.frame(rep(NA,n)),
         "2" = padding<-data.frame(rep(NA,n), rep(NA,n)),
         "3" = padding<-data.frame(rep(NA,n), rep(NA,n), rep(NA,n)),
         "4" = padding<-data.frame(rep(NA,n), rep(NA,n), rep(NA,n), 
                                   rep(NA,n)))
  return(padding)
}

stitch.rows <- function(data, list.hairs){
  max.hairs <- max(as.numeric(list.hairs))
  max.rows <- findnorows(max.hairs)
  n <- as.numeric(nrow(data[[1]]))
  row.names <- rep(NA,max.rows)
  for(j in 1:max.rows) row.names[j] <- paste("row", j, sep = "")
  parameter.names <- colnames(data[[1]][, 1:3])
  name <- list.hairs[1]
  nohairs <- as.numeric(name)
  alldata.row <- data[[name]]
  norows <- findnorows(nohairs)
  diff.row <- max.rows-norows
  temp.row.names<-row.names[2:max.rows]
  padding <- pad.rows(diff.row)
  colnames(padding)<-temp.row.names
  alldata.row <- cbind(alldata.row, padding)
  alldata.row <-alldata.row[c(parameter.names,"array",row.names)]
  for (i in 2:length(list.hairs)){
    name<-list.hairs[i]
    nohairs<-as.numeric(name)
    temp.data<-data[[name]]
    norows<-findnorows(nohairs)
    diff.row<-max.rows-norows
    if(diff.row!=0){
      pad.row<-pad.rows(diff.row)
      temp.row.names<-row.names[(norows+1):max.rows]
      colnames(pad.row)<-temp.row.names
      data.ready<-cbind(temp.data,pad.row)
    }else{
      data.ready <- temp.data
    }
    data.ready<-data.ready[c(parameter.names,"array",row.names)]
    alldata.row<-rbind(alldata.row,data.ready)
    rm(data.ready)
  }
  array.names <- rep(NA,length(list.hairs))
  for(n in 1:length(list.hairs)) array.names[n] <- paste(list.hairs[n], "hair", sep = "")
  alldata.row$array <- factor(alldata.row$array, levels = array.names)
  return(alldata.row)
}

plot.hairs <- function(nohairs){
  data <- read.table(file = paste("../data/vertex-files/",
                                  nohairs, "hair_files/hairs0.vertex", sep = ""),
                     skip = 1, header = FALSE)
  csv.data <- read.csv(file = paste("../data/csv-files/", 
                                    nohairs, "hair_files/hairs0.csv", sep = ""))
  data$antorhair <- c(rep("ant",csv.data[1,1]),
                      rep("hair",(csv.data[1,2]*nohairs)))
  colnames(data)<-c("x","y","antorhair")
  return(data)
}
