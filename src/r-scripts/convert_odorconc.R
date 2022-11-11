library(ggplot2)
library(viridis)
library(RColorBrewer)

source("./src/R-scripts/datahandling_functions.R")

run_id <- "0004"
hairno <- 3
hair.conc <- convert_odorconc(run_id, fluid, hairno)
all.data <- convert_ibamr(run_id, fluid, 1, hairno)
max_fill <- max(all.data$c)
hair.points <- as.data.frame(t(hair.conc$hairs.positions))
conc.timedata <- R.matlab::readMat(paste("./results/odorcapture/", hairno, "hair_array/", 
                              "c_", run_id, ".mat", sep = ""))
init.data <- R.matlab::readMat(paste("./results/odorcapture/", hairno, "hair_array/", 
                              "initdata_", run_id, ".mat", sep = ""))

#for (i in 1:22){
  i=1
   all.data$c <- as.vector(conc.timedata[[i]])
   ggplot(all.data, aes(x = x, y = y, fill = c)) + geom_tile() +
      scale_fill_distiller(name = "Conc", type = "seq", palette = "OrRd", direction = 1,
                           limits = c(-0.01, max_fill)) +
      geom_point(data = hair.points, mapping = aes(x = x, y = y), pch = 19, size = 1,
                 col = "black", fill = "black") +
      theme_bw()
   ggsave(paste0("conc_",run_id,"_",i,".png"),last_plot())
#}

ggplot(all.data, aes(x = x, y = y, fill = w)) +
 geom_tile() + scale_fill_viridis() +
 geom_point(data = hair.points, mapping = aes(x = x, y = y),
            pch = 19, size = 1, col = "white", fill = "white")+
  theme_minimal()

hair.conc <- convert_odorconc(run_id, fluid, hairno)
hair.conc$conc.data <- hair.conc$conc.data/sum(conc.timedata$c.1)
row.cols <- viridis(hairno, option = "C")
cols <- c(rep(row.cols[1], 3),
          rep(row.cols[2], 4),
          rep(row.cols[3], 5),
          rep(row.cols[4], 6),
          rep(row.cols[5], 7))

plot(apply(hair.conc$conc.data, 1, sum),
     xlab = "Print time", ylab = "Odorant", pch = 19, col = "black", type = "l")
for (i in 1:length(hair.conc$conc.data[1, ])){
  lines(hair.conc$conc.data[, i], lty = 1, col = row.cols[i])
}
legend("topleft", legend = c("total", "hair 1", "hair 2", "hair 3"), 
       col = c("black", row.cols), lty = rep(1,4))

slopes <- rep(NA, length(hair.conc$conc.data[, 1]) - 1)
for(i in 1:(length(hair.conc$conc.data[, 1]) - 1)){
  slopes[i] <- (sum(hair.conc$conc.data[i + 1, ]) - sum(hair.conc$conc.data[i, ])) / 
    (500 * init.data$dt)
}

plot(slopes, xlab = "Print time", ylab = "Change in odorant",ylim=c(0,max(slopes)))
lines(slopes)
lines(c(0, length(hair.conc$conc.data[, 1])), c(1e-1, 1e-1), col = "red", lty = 2)


