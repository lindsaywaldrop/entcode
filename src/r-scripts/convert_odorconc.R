library(ggplot2)
library(viridis)
library(R.matlab)
library(png)

convert_odorconc <- function(run_id,fluid,hairno) {
  require(R.matlab)
  data<-readMat(paste("./results/odorcapture/",hairno,"hair_array/",fluid,"/hairs_c_",run_id,".mat", sep = ""))
  steps.number <- length(data) - 2
  hairs.number <- length(data$hairs.center[, 1])
  conc.data <- matrix(NA, ncol = hairs.number, nrow = steps.number)
  colnames(conc.data) <- paste("h", as.character(1:hairs.number), sep = "")
  rownames(conc.data) <- as.character(1:steps.number)
  hairs.positions <- t(data$hairs.center)
  colnames(hairs.positions) <- paste("h", as.character(1:hairs.number), sep = "")
  rownames(hairs.positions) <- c("x", "y")
  for (i in 1:steps.number){
    for (j in 1:hairs.number){
      a <- data[[paste("hairs.c.", i, sep = "")]][[j]][[1]]
      if (length(a)==0) { conc.data[i,j] <- 0 }
      else {conc.data[i,j] <- sum(data[[paste("hairs.c.", i, sep = "")]][[j]][[1]])}
    }
  }
  extracted<-list(hairs.positions=hairs.positions,conc.data=conc.data)
  return(extracted)
}

magnitude <- function(u,v) {
  it <- sqrt(u^2 + v^2)
  it <- replace(it, is.na(it), 0)
}

convert_ibamr <- function(run_id,fluid,t,hairno) {
  require(R.matlab)
  loc.data<-readMat(paste("./results/odorcapture/",hairno,"hair_array/",fluid,"/initdata_",run_id,".mat",sep = ""))
  ibamr.data<-readMat(paste("./results/odorcapture/",hairno,"hair_array/",fluid,"/velocity_",run_id,".mat", sep = ""))
  conc.timedata<-readMat(paste("./results/odorcapture/",hairno,"hair_array/",fluid,"/c_",run_id,".mat",sep = ""))
  u <- as.vector(ibamr.data$u.flick)
  v <- as.vector(ibamr.data$v.flick)
  x <- as.vector(matrix(loc.data$x, nrow = nrow(loc.data$x), ncol = nrow(loc.data$y)))
  y <- as.vector(matrix(loc.data$y, nrow = nrow(loc.data$x), ncol = nrow(loc.data$y), byrow = TRUE))
  c1<- as.vector(conc.timedata[[t]])
  all.data <- data.frame(x = x, y = y, u = u, v = v, w = magnitude(u, v),c=c1)
  return(all.data)
}


run_id="0001"
fluid<-"air"
hairno<-18
hair.conc <- convert_odorconc(run_id,fluid,hairno)
all.data<-convert_ibamr(run_id,fluid,1,hairno)
max_fill<-max(all.data$c)
hair.points <- as.data.frame(t(hair.conc$hairs.positions))
conc.timedata<-readMat(paste("./results/odorcapture/",hairno,"hair_array/",fluid,"/c_",run_id,".mat",sep = ""))
for (i in 1:20){
  all.data$c<- as.vector(conc.timedata[[i]])
  png(filename=paste("conc_",run_id,"_",i,".png",sep=""))
  print({
    ggplot(all.data, aes(x=x,y=y,fill=c)) + geom_tile() + scale_fill_viridis(option="C",limits=c(-0.01,max_fill)) +
      geom_point(data=hair.points,mapping=aes(x=x,y=y),pch=19,size=1,col="white",fill="white") 
    })
  dev.off()
}

ggplot(all.data, aes(x=x,y=y,fill=w)) + geom_tile() + scale_fill_viridis() +
  geom_point(data=hair.points,mapping=aes(x=x,y=y),pch=19,size=1,col="white",fill="white") 



hair.conc <- convert_odorconc(run_id,fluid,hairno)
row.cols<-viridis(5,option="C")
cols <- c(rep(row.cols[1],3),
          rep(row.cols[2],4),
          rep(row.cols[3],5),
          rep(row.cols[4],6),
          rep(row.cols[5],7))
plot(hair.conc$conc.data[,1],
     xlab="time",ylab="Odorant", pch=19,col=cols[1],type='l',
     ylim=range(hair.conc$conc.data))
for (i in 2:length(hair.conc$conc.data[1,])){
  lines(hair.conc$conc.data[,i],pch=19,col=cols[i])
}
