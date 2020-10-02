# Generates grid for use with Constraint IB Method IBAMR
# GtD = gap to diameter ratio between hairs
# dist = distance from antennule
# theta = angle of center hair with positive x-axis
#
# To run this R script on Bridges, enter the following commands: 
# - module add R
# - R   ## This will start R!##
# - source('generate_lineouts.R')  ## Follow prompts if installing packages
# - quit()
# - n

nohairs <- 25  # 1 row: 5, 3 row: 12, 4 row: 18, 5 row: 25

startrun <- 1
endrun <- 165

if (nohairs == 5) {
  hairendpts <- data.frame(starthair = c(5), endhair = c(4))
}else {
  hairendpts <- data.frame(starthair = c(3, 7, 8, 13, 19), endhair = c(2, 6, 12, 18, 25))
}

#### Defines function ####

generateLineout <- function(starthair, endhair, startrun, endrun){
  filename2 <- paste("./data/lineout-files/lineout_h", starthair, "-h", endhair, ".txt", sep = "")   # Defines file name
  if(file.exists(filename2)) file.remove(filename2)  # Deletes file with that name if it exists
  for (p in startrun:endrun){
    hair.data <- read.csv(paste("./data/csv-files/",nohairs,"hair_files/hairs", p, ".csv", sep = ""))
    l <- sqrt((hair.data[2, starthair + 1] - hair.data[2, endhair + 1])^2 + (hair.data[3, starthair + 1] - hair.data[3, endhair + 1])^2)
    cat(c(as.character(p),
          as.character(hair.data[2, starthair + 1]), as.character(hair.data[3, starthair + 1]),
          as.character(hair.data[2, endhair + 1]), as.character(hair.data[3, endhair + 1]),
         as.character(l), "\n"),
        file = filename2, sep = "\t", append = TRUE)
  }
}

##### Runs function ####
for (i in 1:length(hairendpts[, 1])) generateLineout(hairendpts[i, 1], hairendpts[i, 2], startrun, endrun)
