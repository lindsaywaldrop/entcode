
library(ggplot2)
library(RColorBrewer)

source("./src/R-scripts/analysis_functions.R")

run_id <- "0001"
fluid <- "water"
hairno <- 5
hair.conc <- convert_odorconc(run_id, fluid, hairno)
all.data <- convert_ibamr(run_id, fluid, 1, hairno)
max_fill <- max(all.data$c)
hair.points <- as.data.frame(t(hair.conc$hairs.positions))
conc.timedata <- R.matlab::readMat(paste("./results/odorcapture/", hairno, "hair_array/", 
                               fluid, "/c_", run_id, ".mat", sep = ""))
for (i in 1:10){
  all.data$c <- as.vector(conc.timedata[[i]])
  png::png(filename = paste("conc_", run_id, "_", i, ".png", sep = ""), 
      height = 3, width = 4, units = "in", res = 600)
  print({
    ggplot(all.data, aes(x = x, y = y, fill = c)) + geom_tile() + 
      scale_fill_distiller(name = "Conc", type = "seq", palette = "OrRd", direction = 1, 
                           limits = c(-0.01, max_fill)) +
      geom_point(data = hair.points, mapping = aes(x = x, y = y), pch = 19, size = 1,
                 col = "black", fill = "black") + 
      theme_bw()
    })
  dev.off()
}

ggplot(all.data, aes(x = x, y = y, fill = w)) + 
  geom_tile() + scale_fill_viridis() +
  geom_point(data = hair.points, mapping = aes(x = x, y = y), 
             pch = 19, size = 1, col = "white", fill = "white") 

hair.conc <- convert_odorconc(run_id, fluid, hairno)
row.cols <- viridis(5, option = "C")

cols <- c(rep(row.cols[1], 3),
          rep(row.cols[2], 4),
          rep(row.cols[3], 5),
          rep(row.cols[4], 6),
          rep(row.cols[5], 7))
plot(hair.conc$conc.data[, 1],
     xlab = "time", ylab = "Odorant", pch = 19, col = cols[1], type = "l",
     ylim = range(hair.conc$conc.data))

for (i in 2:length(hair.conc$conc.data[1, ])){
  lines(hair.conc$conc.data[, i], pch = 19, col =cols[i])
}

