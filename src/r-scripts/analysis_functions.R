#### R Analysis Functions ####

calculatemaxshear <- function(data, ignore){
  len <- length(data[, 1])
  shear <- matrix(NA, nrow = (len - 1), ncol = 2)
  shear[, 1] <- data[2:len, 1]
  for(ii in 2:(length(data[, 1] - 1))){
    shear[ii - 1, 2] <- (data[ii, 2] - data[ii - 1, 2])/(data[ii, 1] - data[ii - 1, 1])
  }
  shear <- shear[ignore:len - 1,]
  return(max(abs(shear[, 2])))
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
