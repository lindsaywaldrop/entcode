# Generates grid for use with Constraint IB Method IBAMR
# GtD = gap to diameter ratio between hairs
# dist = distance from antennule
# theta = angle of center hair with positive x-axis
#
#To run this R script on Bridges, enter the following commands:
#- module add R
#- R ##this will start R##
#- source('generate_grid2dSY.R') ##follow prompts if installing packages
#- quit
#- n

#### Loads required packages ####
packages <- c("pracma", "useful")

package.check <- lapply(
  packages,
  FUN <- function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE, repos='http://cran.us.r-project.org')
      library(x, character.only = TRUE)
    }
  }
)

####For automating production of vertex files####
startrun <- 1
endrun <- 165

#### Sets up directories ####
mainDir1 <- "./data/vertex-files"
mainDir2 <- "./data/csv-files"
subDir1 <- paste(5,"hair_files",sep="")
dir.create(file.path(mainDir1, subDir1), showWarnings = FALSE)
dir.create(file.path(mainDir2, subDir1), showWarnings = FALSE)

#### Defines functions ####
circle <- function(center, radius, L, dx){
  x_grid <- seq(-radius, radius, by = dx)
  y_grid <- seq(-radius, radius, by = dx)
  whole_grid <- meshgrid(x_grid, y_grid)
  
  THETA <- c(seq(0, 2*pi, length = 250), 0)
  RHO <- array(1, length(THETA)) * radius
  Z <- array(1, length(RHO)) * 0
  nap <- matrix(c(THETA, RHO), nrow = length(THETA), ncol = 2)
  points <- pol2cart(RHO, THETA)
  points <- as.data.frame(points)
  
  In <- inpolygon(whole_grid$X, whole_grid$Y, points$x, points$y, boundary = FALSE)
  Xin <- whole_grid$X[In]
  Yin <- whole_grid$Y[In]
  
  X <- Xin + center[1]
  Y <- Yin + center[2]
  circ <- data.frame(X, Y)
  return(circ)
}

makehairs <- function(th, GtD, number){
  
  ##### Input parameter definitions ####
  
  #th=0
  L <- 2.0         # length of computational domain (m)
  N <- 1024        # number of Cartesian grid meshwidths at the finest level of the AMR grid
  dx <- 1.0 * (L/N)  # Cartesian mesh width (m)
  # Notes ~ Rule of thumb: 2 boundary points per fluid grid point. 
  #        vertex pts too far apart: flow thru boundary, too close: numerical weirdness
  NFINEST <- 4  # NFINEST = 4 corresponds to a uniform grid spacing of h=1/64
  kappa_target <- 1.0e-2        # target point penalty spring constant (Newton)
  
  hdia <- 0.01     # Diameter of hair
  adia <- 0.1     # Diameter of flagellum
  
  th2 <- (th/180) * pi      # Angle off positive x-axis in radians
  #GtD = 6.0787      # Gap width to diameter ratio
  dist <- 0.02     # Distance between antennule and hair 
  mindGap <- (0.5 * adia) + (0.5 * hdia) + dist  # Calculate distance between hair centers
  width <- GtD * hdia + hdia
  
  #### Calculates center positions (x,y) of each hair ####
  hair1Centerx <- mindGap * cos(th2)
  hair1Centery <- mindGap * sin(th2)
  
  hair2Centerx <- hair1Centerx - width * sin(th2)
  hair2Centery <- hair1Centery + width * cos(th2)
  
  hair3Centerx <- hair1Centerx + width * sin(th2)
  hair3Centery <- hair1Centery - width * cos(th2)
  
  hair4Centerx <- hair2Centerx - width * sin(th2)
  hair4Centery <- hair2Centery + width * cos(th2)
  
  hair5Centerx <- hair3Centerx + width * sin(th2)
  hair5Centery <- hair3Centery - width * cos(th2)
  
  #### Produces points within defined hairs ####
  
  # Antennule
  ant <- circle(c(0, 0), 0.5 * adia, L, dx);  # Produces points that define antennule
  aN <- size(ant$X, 2)                   # Records number of points inside antennule
  #plot(0, 0, xlim = c(-0.25, 0.25), ylim = c(-0.25, 0.25), pch = 19, cex = 4.5) #Plots antennule
  
  # Hair 1
  h1 <- circle(c(hair1Centerx, hair1Centery), 0.5 * hdia, L, dx)
  h1N <- size(h1$X, 2)
  disp(h1N)
  #points(hair1Centerx, hair1Centery, pch = 19, cex = 2.5)
  #text(hair1Centerx, hair1Centery, labels = "1", col = "red")
  
  # Hair 2
  h2 <- circle(c(hair2Centerx, hair2Centery), 0.5 * hdia, L, dx)
  h2N <- size(h2$X, 2)
  disp(h2N)
  #points(hair2Centerx, hair2Centery, pch = 19, cex = 2.5)
  #text(hair2Centerx, hair2Centery, labels = "2", col = "red")
  
  # Hair 3
  h3 <- circle(c(hair3Centerx, hair3Centery), 0.5 * hdia, L, dx)
  h3N <- size(h3$X, 2)
  disp(h3N)
  #points(hair3Centerx, hair3Centery, pch = 19, cex = 2.5)
  #text(hair3Centerx, hair3Centery, labels = "3", col = "red")
  
  # Hair 4
  h4 <- circle(c(hair4Centerx, hair4Centery), 0.5 * hdia, L, dx)
  h4N <- size(h4$X, 2)
  disp(h4N)
  #points(hair4Centerx, hair4Centery, pch = 19, cex = 2.5)
  #text(hair4Centerx, hair4Centery, labels = "4", col = "red")
  
  # Hair 5
  h5 <- circle(c(hair5Centerx, hair5Centery), 0.5 * hdia, L, dx)
  h5N <- size(h5$X, 2)
  disp(h5N)
  #points(hair5Centerx, hair5Centery, pch = 19, cex = 2.5)
  #text(hair5Centerx, hair5Centery, labels ="5", col = "red")
  
  #### Write points to vertex file ####
  
  totalN <- aN + h1N + h2N + h3N + h4N + h5N  # Calculates total number of points (first line of vertex file)
  
  filename <- paste("./data/vertex-files/5hair_files/hairs", number, ".vertex", sep = "")   # Defines file name
  if(file.exists(filename)) file.remove(filename)  # Deletes file with that name if it exists
  cat(as.character(totalN), sep = "\n", file = filename, append = TRUE)
  for (i in 1:aN){
    cat(c(as.character(ant$X[i]), " ", as.character(ant$Y[i]), "\n"), file = filename, sep = "", append = TRUE)
  }
  for (i in 1:h1N){
    cat(c(as.character(h1$X[i]), " ", as.character(h1$Y[i]), "\n"), file = filename, sep = "", append = TRUE)
  }
  for (i in 1:h2N){
    cat(c(as.character(h2$X[i]), " ", as.character(h2$Y[i]), "\n"), file = filename, sep = "", append = TRUE)
  }
  for (i in 1:h3N){
    cat(c(as.character(h3$X[i]), " ", as.character(h3$Y[i]), "\n"), file = filename, sep = "", append = TRUE)
  }
  for (i in 1:h4N){
    cat(c(as.character(h4$X[i]), " ", as.character(h4$Y[i]), "\n"), file = filename, sep = "", append = TRUE)
  }
  for (i in 1:h5N){
    cat(c(as.character(h5$X[i]), " ", as.character(h5$Y[i]), "\n"), file = filename, sep = "", append = TRUE)
  }
  a <- c(aN, 0, 0)
  h1 <- c(h1N, hair1Centerx, hair1Centery)
  h2 <- c(h2N, hair2Centerx, hair2Centery)
  h3 <- c(h3N, hair3Centerx, hair3Centery)
  h4 <- c(h4N, hair4Centerx, hair4Centery)
  h5 <- c(h5N, hair5Centerx, hair5Centery)
  write.csv(data.frame(a, h1, h2, h3, h4, h5), 
            file = paste("./data/csv-files/5hair_files/hairs", number, ".csv", sep = ""), 
            row.names = FALSE)
}

####Input parameter definitions####

parameters <- read.table("./data/parameters/allpara_165.txt")
names(parameters) <- c("angle", "gap", "Re")

for (i in startrun:endrun){
  makehairs(parameters$angle[i], parameters$gap[i],i)
}
