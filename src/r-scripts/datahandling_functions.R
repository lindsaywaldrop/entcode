findnorows <- function(nohairs){
  norows <- switch(as.character(nohairs),
                   "3" = 1,
                   "5" = 1,
                   "7" = 2,
                   "12" = 3,
                   "18" = 4,
                   "25" = 5)
  return(norows)
}

reordercols<- function(data,nohairs,datatype){
  parameter.names<-colnames(data[1:3])
  if(datatype=="leakiness"){
    norows<-findnorows(nohairs)
    rownames <- as.character(rep(0, norows))
    for (i in 1:norows) rownames[i] <- paste("row", i, sep = "") 
    new.order <- c(parameter.names, "array", rownames)
  }else if(datatype=="totalconc_water" || datatype == "totalconc_air"){
    norows<-findnorows(nohairs)
    rownames <- as.character(rep(0, norows))
    for (i in 1:norows) rownames[i] <- paste("row", i, sep = "") 
    hairnames <- as.character(rep(0, nohairs)) # Allocates space for names 
    for (i in 1:nohairs) hairnames[i] <- paste("hair", i, sep = "") 
    new.order <- c(parameter.names,"array","total.conc",hairnames,rownames)
  }else {
    hairnames <- as.character(rep(0, nohairs)) # Allocates space for names 
    for (i in 1:nohairs) hairnames[i] <- paste("hair", i, sep = "") 
    new.order <- c(parameter.names,"array",hairnames)
  }
  newdata <- data[,new.order]
  return(newdata)
}

loadnshapedata<-function(n,datatype,nohairs,date) {
  data <- read.csv(paste("../results/r-csv-files/",nohairs,"hair_results/", datatype, "_", n, "_", date, ".csv", sep = ""))
  columns <- colnames(data)
  data2 <- data.frame(data, rep(paste(nohairs, "hair", sep = ""), length = n))
  colnames(data2) <- c(columns, "array")
  data.final <- reordercols(data2,nohairs,datatype)
  return(data.final)
}

stitchdata <- function(n,datatype,data1,data2,nohairs1,nohairs2){
  if(datatype=="leakiness"){
    norows1<-findnorows(nohairs1)
    norows2<-findnorows(nohairs2)
    deltah <- norows2 - norows1
    repnames <- colnames(data1)
    for (i in 1:deltah) {
      data1 <- cbind(data1, rep(NA,length=n))
      repnames <- c(repnames,paste("row",(norows1+i),sep=""))
    }
    colnames(data1)<-repnames
  } else {
    deltah <- nohairs2 - nohairs1
    repnames <- colnames(data1)
    for (i in 1:deltah) {
      data1 <- cbind(data1, rep(NA,length=n))
      repnames <- c(repnames,paste("hair",(nohairs1+i),sep=""))
    }
    colnames(data1)<-repnames
  }
  alldata <- rbind(data1,data2)
  return(alldata)
}

pad.rows<-function(diff.row){
  padding=0
  switch(diff.row,
         "1" = padding<-data.frame(rep(NA,n)),
         "2" = padding<-data.frame(rep(NA,n), rep(NA,n)),
         "3" = padding<-data.frame(rep(NA,n), rep(NA,n), rep(NA,n)),
         "4" = padding<-data.frame(rep(NA,n), rep(NA,n), rep(NA,n), 
                                   rep(NA,n)))
  return(padding)
}

stitch.rows <- function(data, list.hairs){
  max.hairs <- max(as.numeric(list.hairs))
  max.rows <- findnorows(max.hairs)
  n <- as.numeric(nrow(data[[1]]))
  row.names <- rep(NA,max.rows)
  for(j in 1:max.rows) row.names[j] <- paste("row", j, sep = "")
  parameter.names <- colnames(data[[1]][, 1:3])
  name <- list.hairs[1]
  nohairs <- as.numeric(name)
  alldata.row <- data[[name]]
  norows <- findnorows(nohairs)
  diff.row <- max.rows-norows
  temp.row.names<-row.names[2:max.rows]
  padding <- pad.rows(diff.row)
  colnames(padding)<-temp.row.names
  alldata.row <- cbind(alldata.row, padding)
  alldata.row <-alldata.row[c(parameter.names,"array",row.names)]
  for (i in 2:length(list.hairs)){
    name<-list.hairs[i]
    nohairs<-as.numeric(name)
    temp.data<-data[[name]]
    norows<-findnorows(nohairs)
    diff.row<-max.rows-norows
    if(diff.row!=0){
      pad.row<-pad.rows(diff.row)
      temp.row.names<-row.names[(norows+1):max.rows]
      colnames(pad.row)<-temp.row.names
      data.ready<-cbind(temp.data,pad.row)
    }else{
      data.ready <- temp.data
    }
    data.ready<-data.ready[c(parameter.names,"array",row.names)]
    alldata.row<-rbind(alldata.row,data.ready)
    rm(data.ready)
  }
  return(alldata.row)
}
