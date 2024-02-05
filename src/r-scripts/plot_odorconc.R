library(ggplot2)
library(viridis)
library(RColorBrewer)
library(colorspace)
library(patchwork)

source("./src/R-scripts/datahandling_functions.R")

run_id <- "8235"
hairno <- 3
hair.conc <- convert_odorconc(run_id, fluid, hairno)
all.data <- convert_ibamr(run_id, fluid, 1, hairno)
max_fill <- max(all.data$c)
hair.points <- as.data.frame(t(hair.conc$hairs.positions))
hair.points$name <- rep(NA, nrow(hair.points))
for (i in 1:hairno) hair.points$name[i] <- paste("hair", i, sep = "_")
hair.points$name <- factor(hair.points$name, ordered = T, hair.points$name)
conc.timedata <- R.matlab::readMat(paste("./results/odorcapture/", hairno, "hair_array/", 
                              "c_", run_id, ".mat", sep = ""))
init.data <- R.matlab::readMat(paste("./results/odorcapture/", hairno, "hair_array/", 
                                         "initdata_", run_id, ".mat", sep = ""))

dir.create("documents/viz/")
dir.create(paste0("documents/viz/",hairno,"hair-run",run_id))
all.ctotals <- rep(NA, length(conc.timedata))
hair_totals <- data.frame("time" = seq(init.data$dt, length(conc.timedata)*init.data$dt*init.data$print.time, 
                                       by = init.data$dt*init.data$print.time), 
                          hair.conc$conc.data)
colnames(hair_totals) <- c("time", as.character(hair.points$name))
hair_totals_long <- tidyr::pivot_longer(hair_totals, cols = !time)
hair_totals_long$name <- factor(hair_totals_long$name, ordered = T, 
                                levels = as.character(hair.points$name))
#for(i in seq(1,length(conc.timedata), by = 10)){
#for (i in 1:length(conc.timedata)){
#for (i in 1:50){
  i=1
   all.data$c <- as.vector(conc.timedata[[i]])
   all.ctotals[i]<-sum(all.data$c)
   p1 <- ggplot(all.data, aes(x = x, y = y, fill = c)) + 
     geom_tile() +
     scale_fill_continuous_sequential(palette = "Reds", 
                           limits = c(-0.01, max_fill), name = "Concentration") +
     geom_point(data = hair.points, mapping = aes(x = x, y = y, fill = NULL), 
                pch = 19, size = 2.5, color = "black") +
     geom_point(data = hair.points, mapping = aes(x = x, y = y, color = name, fill = NULL), 
                pch = 19, size = 2) +
     scale_color_viridis(discrete = T, guide = "none") +
     theme_bw() +
     theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
   p2 <- ggplot(hair_totals_long[hair_totals_long$time <= 
                                   rep(i*init.data$dt*init.data$print.time, 
                                       nrow(hair_totals_long)),], 
                aes(time, value, color = name)) + 
     geom_point(pch = 19, size = 1) + 
     scale_color_viridis(discrete = T, guide = "none") +
     ylab("Concentration") + xlab("Simulation time (s)") +
     xlim(0, max(hair_totals_long$time)) + 
     ylim(0, max(hair_totals_long$value)) + 
     theme_minimal()
   p1 / p2   + plot_layout(heights = c(2,1))
   ggsave(paste0("documents/viz/",hairno,"hair-","run",run_id,"/conc_",run_id,"_",i,".png"),last_plot())
#}


# Plot velocity field
 ggplot(all.data, aes(x = x, y = y, fill = w)) +
   geom_tile() + scale_fill_viridis() +
   geom_point(data = hair.points, mapping = aes(x = x, y = y),
              pch = 19, size = 1, col = "white", fill = "white")+
   theme_minimal()

