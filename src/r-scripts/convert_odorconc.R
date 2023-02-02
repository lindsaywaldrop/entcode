library(ggplot2)
library(viridis)
library(RColorBrewer)

source("./src/R-scripts/datahandling_functions.R")

run_id <- "1401"
hairno <- 3
hair.conc <- convert_odorconc(run_id, fluid, hairno)
all.data <- convert_ibamr(run_id, fluid, 1, hairno)
max_fill <- max(all.data$c)
hair.points <- as.data.frame(t(hair.conc$hairs.positions))
conc.timedata <- R.matlab::readMat(paste("./results/odorcapture/", hairno, "hair_array/", 
                              "c_", run_id, ".mat", sep = ""))
dir.create("documents/viz/")
dir.create(paste0("documents/viz/run",run_id))
 for (i in 1:length(conc.timedata)){
#  i=1
   all.data$c <- as.vector(conc.timedata[[i]])
   ggplot(all.data, aes(x = x, y = y, fill = c)) + geom_tile() +
      scale_fill_distiller(name = "Conc", type = "seq", palette = "OrRd", direction = 1,
                           limits = c(-0.01, max_fill)) +
      geom_point(data = hair.points, mapping = aes(x = x, y = y), pch = 19, size = 1,
                 col = "black", fill = "black") +
      theme_bw()
#    ggsave(paste0("documents/viz/run",run_id,"/conc_",run_id,"_",i,".png"),last_plot())
}


# ggplot(all.data, aes(x = x, y = y, fill = w)) +
#   geom_tile() + scale_fill_viridis() +
#   geom_point(data = hair.points, mapping = aes(x = x, y = y),
#              pch = 19, size = 1, col = "white", fill = "white")+
#   theme_minimal()





checkruns<-function(run_id){
  hairno <- 3
  init.data <- R.matlab::readMat(paste("./results/odorcapture/", hairno, "hair_array/", 
                                       "initdata_", run_id, ".mat", sep = ""))
  
  print.time <- init.data$print.time
  threshold <- init.data$ctotal*0.01
  print(threshold)
  hair.conc <- convert_odorconc(run_id, fluid, hairno)
  #hair.conc$conc.data <- hair.conc$conc.data/sum(conc.timedata$c.1)
  row.cols <- viridis(hairno, option = "C")
  cols <- c(rep(row.cols[1], 3),
            rep(row.cols[2], 4),
            rep(row.cols[3], 5),
            rep(row.cols[4], 6),
            rep(row.cols[5], 7))
  plot.conc <- apply(hair.conc$conc.data, 1, sum)
  plot(y = plot.conc, x = seq(1,length(plot.conc))*as.numeric(init.data$dt*print.time),
       xlab = "Simulation time", ylab = "Odorant", pch = 19, col = "black", type = "l", 
       main = paste0("Simulation ", run_id))
  for (i in 1:length(hair.conc$conc.data[1, ])){
    lines(x = seq(1,length(plot.conc))*as.numeric(init.data$dt*print.time), y = hair.conc$conc.data[, i], lty = 1, col = row.cols[i])
  }
  legend("topleft", legend = c("total", "hair 1", "hair 2", "hair 3"), 
         col = c("black", row.cols), lty = rep(1,4))
  
  slopes <- rep(NA, length(plot.conc) - 1)
  for(i in 1:(length(plot.conc) - 1)){
    slopes[i] <- (plot.conc[i + 1] - plot.conc[i]) / 
      (init.data$dt*print.time)
  }
  
  plot(y=slopes, x = seq(1,length(slopes))*as.numeric(init.data$dt*print.time),
       xlab = "Print time", ylab = "Change in odorant", 
       ylim=c(0,max(slopes)),
       #xlim=c(0, 5e-2),
       main = paste0("Simulation ", run_id))
  lines(y=slopes, x = seq(1,length(slopes))*as.numeric(init.data$dt*print.time))
  lines(c(0, length(hair.conc$conc.data[, 1])), c(threshold, threshold), col = "red", lty = 2)
  lines(c(1e-2,1e-2), c(0, 1000*init.data$ctotal), col="blue")
  
  plot(slopes/threshold, ylim=c(0,20),type="l")
  lines(c(0,4000), c(1,1))
  slopes[length(slopes)] < threshold
}

checkruns("1401")
