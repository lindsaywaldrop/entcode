library(ggplot2)
library(viridis)
library(RColorBrewer)

source("./src/R-scripts/datahandling_functions.R")

run_id <- "0012"
hairno <- 3
hair.conc <- convert_odorconc(run_id, fluid, hairno)
all.data <- convert_ibamr(run_id, fluid, 1, hairno)
max_fill <- max(all.data$c)
hair.points <- as.data.frame(t(hair.conc$hairs.positions))
conc.timedata <- R.matlab::readMat(paste("./results/odorcapture/", hairno, "hair_array/", 
                              "c_", run_id, ".mat", sep = ""))
dir.create("documents/viz/")
dir.create(paste0("documents/viz/run",run_id))
all.ctotals <- rep(NA, length(conc.timedata))
 for (i in 1:length(conc.timedata)){
#  i=1
   all.data$c <- as.vector(conc.timedata[[i]])
   all.ctotals[i]<-sum(all.data$c)
   #ggplot(all.data, aes(x = x, y = y, fill = c)) + geom_tile() +
  #    scale_fill_distiller(name = "Conc", type = "seq", palette = "OrRd", direction = 1,
  #                         limits = c(-0.01, max_fill)) +
  #    geom_point(data = hair.points, mapping = aes(x = x, y = y), pch = 19, size = 1,
   #              col = "black", fill = "black") +
  #    theme_bw()
    #ggsave(paste0("documents/viz/run",run_id,"/conc_",run_id,"_",i,".png"),last_plot())
}


# Plot velocity field
 ggplot(all.data, aes(x = x, y = y, fill = w)) +
   geom_tile() + scale_fill_viridis() +
   geom_point(data = hair.points, mapping = aes(x = x, y = y),
              pch = 19, size = 1, col = "white", fill = "white")+
   theme_minimal()

