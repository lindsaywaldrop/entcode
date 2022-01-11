#################################################################################################################
#################################################################################################################
###
### Combine all R csv files into a single set of results
###
#################################################################################################################

#### Parameters ####
n <- 165

#### Functions ####
# Loads data handling functions
source("src/r-scripts/datahandling_functions.R")

#### Actions ####

# 3-hair array
leakinessdata_3 <- loadnshapedata(n, "leakiness",3, "2020-12-06")
waterdata_3 <- loadnshapedata(n, "totalconc_water", 3, "2020-12-08")
airdata_3 <- loadnshapedata(n, "totalconc_air", 3, "2020-12-08")

combined_3 <- leakinessdata_3[,1:3]
combined_3$leakiness.row1 <- leakinessdata_3$row1
combined_3$concwater <- waterdata_3$total.conc
combined_3$concwater.row1 <- waterdata_3$row1
combined_3$concair <- airdata_3$total.conc
combined_3$concair.row1 <- airdata_3$row1

write.csv(combined_3, 
          file = "results/r-csv-files/3hair_results/combined_3hair_165_2021-03-11.csv")

# 18-hair array

leakinessdata_18 <- loadnshapedata(n,"leakiness",18,"2020-12-02")
waterdata_18 <- loadnshapedata(n,"totalconc_water",18,"2020-12-04")
airdata_18 <- loadnshapedata(n,"totalconc_air",18,"2020-12-04")

combined_18 <- leakinessdata_18[,1:3]
combined_18$leakiness.row1 <- leakinessdata_18$row1
combined_18$leakiness.row2 <- leakinessdata_18$row2
combined_18$leakiness.row3 <- leakinessdata_18$row3
combined_18$leakiness.row4 <- leakinessdata_18$row4
combined_18$concwater <- waterdata_18$total.conc
combined_18$concwater.row1 <- waterdata_18$row1
combined_18$concwater.row2 <- waterdata_18$row2
combined_18$concwater.row3 <- waterdata_18$row3
combined_18$concwater.row4 <- waterdata_18$row4
combined_18$concair <- airdata_18$total.conc
combined_18$concair.row1 <- airdata_18$row1
combined_18$concair.row2 <- airdata_18$row2
combined_18$concair.row3 <- airdata_18$row3
combined_18$concair.row4 <- airdata_18$row4

write.csv(combined_18, 
          file = "results/r-csv-files/18hair_results/combined_18hair_165_2021-03-11.csv")

# 25-hair array 

leakinessdata_25 <- loadnshapedata(n,"leakiness",25,"2020-12-02")
waterdata_25 <- loadnshapedata(n,"totalconc_water",25,"2020-12-04")
airdata_25 <- loadnshapedata(n,"totalconc_air",25,"2020-12-04")

combined_25 <- leakinessdata_25[,1:3]
combined_25$leakiness.row1 <- leakinessdata_25$row1
combined_25$leakiness.row2 <- leakinessdata_25$row2
combined_25$leakiness.row3 <- leakinessdata_25$row3
combined_25$leakiness.row4 <- leakinessdata_25$row4
combined_25$leakiness.row5 <- leakinessdata_25$row5
combined_25$concwater <- waterdata_25$total.conc
combined_25$concwater.row1 <- waterdata_25$row1
combined_25$concwater.row2 <- waterdata_25$row2
combined_25$concwater.row3 <- waterdata_25$row3
combined_25$concwater.row4 <- waterdata_25$row4
combined_25$concwater.row5 <- waterdata_25$row5
combined_25$concair <- airdata_25$total.conc
combined_25$concair.row1 <- airdata_25$row1
combined_25$concair.row2 <- airdata_25$row2
combined_25$concair.row3 <- airdata_25$row3
combined_25$concair.row4 <- airdata_25$row4
combined_25$concair.row5 <- airdata_25$row5

write.csv(combined_25, 
          file = "results/r-csv-files/25hair_results/combined_25hair_165_2021-03-11.csv")

