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

rm(list=ls()) # Clears workspace

startrun=1
endrun=165
starthair=8  #  first row start: 2, second row start: 6, third row start: 8, fourth row start: 13
endhair=12    #  first row end: 3, second row end: 7, third row end: 12, fourth row end: 18

#### Defines functions ####

generateLineout<-function(starthair,endhair,startrun,endrun){
  filename2<-paste("lineout_h",starthair,"-h",endhair,".txt",sep="")   # Defines file name
  if(file.exists(filename2)) file.remove(filename2)  # Deletes file with that name if it exists
  for (p in startrun:endrun){
    hair.data<-read.csv(paste("hairs",p,".csv",sep=""))
    l=sqrt((hair.data[2,starthair+1]-hair.data[2,endhair+1])^2+(hair.data[3,starthair+1]-hair.data[3,endhair+1])^2)
    cat(c(as.character(p),
          as.character(hair.data[2,starthair+1]),as.character(hair.data[3,starthair+1]),
          as.character(hair.data[2,endhair+1]),as.character(hair.data[3,endhair+1]),
          as.character(hair.data[2,1+1]),as.character(hair.data[3,1+1]),
          as.character(hair.data[2,2+1]),as.character(hair.data[3,2+1]),
          as.character(hair.data[2,3+1]),as.character(hair.data[3,3+1]),
          as.character(l),"\n"),
        file=filename2,sep="\t",append=TRUE)
  }
}

##### Runs function ####

generateLineout(starthair,endhair,startrun,endrun)
