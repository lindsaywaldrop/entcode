#################################################################################################################
#################################################################################################################
###
### Plot Results
###
#################################################################################################################

# Loads required libraries
library(ggplot2)
library(scatterplot3d)


# Clears any previous data
rm(list=ls())

maxconc_air<-0.0806  # Calculate: 0.1/ylength from init data file
maxconc_water<-3.1282 # Maximum concentration in simulations
dx_air<-0.0024  # Look up init file
dx_water<-6.1035e-04  # Look up in init file
hairdia<-0.01 # m, hair diameter 
simdur<-20 #s, duration of concentration capture simulation

setwd("/Users/Bosque/Dropbox/EntIBAMR/results/")	# Sets directory to main
Umean<-read.csv("Umean1233-2018-03-27.csv",header=FALSE,skip=1)
shear<-read.csv("shear_hair1233-2017-11-01.csv",header=TRUE)	# Loads file with shear rates in main directory
leakiness<-read.csv("leakiness1233-2017-11-01.csv",header=TRUE)			# Loads file with gapwidth values in main directory
conc_water<-read.csv("ConcWater1233-2018-05-24.csv",header=FALSE)			# Loads file with concentration captured in water values in main directory
conc_air<-read.csv("ConcAir1233-2018-03-20.csv",header=FALSE)			# Loads file with concentration capted in air values in main directory
parameters<-read.table("allpara_1233.txt",sep="\t")

Umean_nond<-Umean*(simdur/hairdia)
shear_nond<-shear*simdur
conc_water_nond<-conc_water$V1*(dx_water^2)/maxconc_water
conc_air_nond<-conc_air$V1*(dx_air^2)/maxconc_air

data<-data.frame(seq(1,1233),parameters$V1,parameters$V2,parameters$V3,Umean_nond$V2,Umean_nond$V3,Umean_nond$V4,shear_nond$hair1bottom,shear_nond$hair2top,shear_nond$hair3top,leakiness$x,conc_water_nond,conc_air_nond)
names(data)<-c("SimNumber","Angle","GapWidth","Re","UmeanHair1","UmeanHair2","UmeanHair3","ShearHair1","ShearHair2","ShearHair3","Leakiness","ConcWater","ConcAir")
summary(data)

## Some stats calculations from Yanyan

calcnorm<-function(x,y){
a = min(x)
b = max(x)
x1=a+(y-min(y))*(b-a)/(max(y)-min(y))
# Calcualtes the norm of the difference betwen leakiness and ConcWater and leakiness and ConcAir
return(norm(as.matrix(x-x1),type=c("2")))
}

calcnorm(data$Leakiness,data$ConcWater)
calcnorm(data$Leakiness,data$ConcAir)


values<-data.frame(data$UmeanHair1,data$UmeanHair2,data$UmeanHair3)
names(values)<-c("V1","V2","V3")
calcnorm(rowMeans(values),data$ConcWater)
calcnorm(rowMeans(values),data$ConcAir)

values<-data.frame(data$ShearHair1,data$ShearHair2,data$ShearHair3)
names(values)<-c("V1","V2","V3")
calcnorm(rowMeans(values),data$ConcWater)
calcnorm(rowMeans(values),data$ConcAir)


#setwd("/Users/Spectre/Dropbox/presentations/ESA2017")
#flickrs<-read.csv("estReGW.csv",header=TRUE)
#flicksdata<-data.frame(flickrs$Species,flickrs$movement,flickrs$Re,flickrs$GW,flickrs$Angle)
#names(flicksdata)<-c("Species","movement","Re","GW","Angle")

######################################
######################################
# Define plotting functions


myColorRamp <- function(colors, values, minmax) {
  v <- (values - min(minmax))/diff(range(minmax))
  x <- colorRamp(colors)(v)
  rgb(x[,1], x[,2], x[,3], maxColorValue = 255)
}

color.bar <- function(colors, values, minmax, nticks, digits) {
	#min=round(min(values),digits=digits)
	min=min(minmax)
	tickmin=min
	#max=round(max(values),digits=digits)
	max=max(minmax)
	ticks=seq(tickmin, max, len=nticks)
#	ticks<-formatC(ticks,format="e",digits=1)
	ticks<-formatC(ticks,digits=digits)
	scale<-seq(from=min,to=max,length.out=100)
	len<-(length(scale)-1)/(max-min)
	x <- myColorRamp(colors,scale,minmax)
    par(mar=c(1,0,1,1))
    plot(c(0,10), c(min,max), type='n', bty='n', xaxt='n', xlab='', yaxt='n', ylab='', main='')
#    axis(2, ticks, las=1,cex.axis=0.8)
    axis(2, at=ticks,labels=ticks, las=1,cex.axis=0.8) #for scientific formating of labels
    for (i in 1:(length(scale)-1)) {
     y = (i-1)/len + min
     rect(0,y,10,y+1/len, col=x[i], border=NA)
    }
}

color.bar2 <- function(colors, values, minmax, nticks, digits) {
	#min=round(min(values),digits=digits)
	min=min(minmax)
	tickmin=min
	#max=round(max(values),digits=digits)
	max=max(minmax)
	ticks=seq(tickmin, max, len=nticks)
#	ticks<-formatC(ticks,format="e",digits=1)
	ticks<-formatC(ticks,digits=digits)
	scale<-seq(from=min,to=max,length.out=100)
	len<-(length(scale)-1)/(max-min)
	y <- myColorRamp(colors,scale,minmax)
    par(mar=c(3,1,1,1))
    plot(c(min,max), c(0,10), type='n', bty='n', xaxt='n', xlab='', yaxt='n', ylab='', main='')
    axis(1, at=ticks,labels=ticks, las=1,cex.axis=1.2) #for scientific formating of labels
    for (i in 1:(length(scale)-1)) {
     x = (i-1)/len + min
     rect(x,0,x+1/len,10, col=y[i], border=NA)
    }
}

new3Dscatterplotcolorbar<-function(colors,values,parameter,minmax,angle,nticks,digits,xadj,yadj){
	layout(matrix(c(1,2,1,2),nrow=1,ncol=2, byrow=TRUE),widths=c(8,1),heights=c(1,2))
with(values, {
  cols <- myColorRamp(colors, parameter, minmax)
  p<-scatterplot3d(Angle, GapWidth, Re, 
            color=cols, pch=19, 
            xlab="Angle",
            ylab=" ",
            zlab="Re",
           # main="Combined Q",
            angle=angle,
            scale.y=1.5,y.margin.add=1,mar=c(3,3,0,1))
dims <- par("usr")
x <- dims[1]+ xadj*diff(dims[1:2])
y <- dims[3]+ yadj*diff(dims[3:4])
text(x,y,expression("Gap Width"),srt=angle-3,font=4)
color.bar(colors,parameter,minmax,nticks=nticks,digits)
})
}

new3Dscatterplot2<-function(colors,values,parameter,minmax,angle,nticks,digits,xadj,yadj){
	#layout(matrix(c(1,2,1,2),nrow=1,ncol=2, byrow=TRUE),widths=c(8,1),heights=c(1,2))
with(values, {
  cols <- myColorRamp(colors, parameter, minmax)
  p<-scatterplot3d(Angle, GapWidth, Re, 
            color=cols, pch=19, 
            xlab="Angle",
            ylab=" ",
            zlab="Re",
           # main="Combined Q",
            angle=angle,
            scale.y=1.5,y.margin.add=1,mar=c(3,3,0,0))
dims <- par("usr")
x <- dims[1]+ xadj*diff(dims[1:2])
y <- dims[3]+ yadj*diff(dims[3:4])
text(x,y,expression("Gap Width"),srt=angle-3,font=4,cex=1.4)
#color.bar(colors,parameter,minmax,nticks=nticks,digits)
})
}

new3Dscatterplot<-function(colors,values,labels,angle,nticks,xadj,yadj){
with(values, {
  cols <- myColorRamp(colors, values$V3,range(values$V3))
#  xticks<-round(seq(from=0,to=signif(max(values$V1),digits=1),length=nticks))
#  yticks<-round(seq(from=0,to=signif(max(values$V2),digits=1),length=nticks))
#  zticks<-seq(from=0,to=signif(max(values$V3),digits=2),length=nticks)
  p<-scatterplot3d(values$V1, values$V2, values$V3, 
            color=cols, pch=19, 
            xlab=labels[1],
            ylab=" ",
            zlab=labels[3],
            main=labels[4],
#            tick.marks=TRUE, label.tick.marks=TRUE, 
            lab.z=nticks,
#            x.ticklabs=xticks, y.ticklabs=yticks, z.ticklabs=zticks,
            angle=angle,
            scale.y=0.5,y.margin.add=1,mar=c(3,3,1,0))#,type="h")
            #zlim=c(0,12))
 # p.coords<-p$xyz.convert(values$V1,values$V2,values$V3)
 #text(p.coords$x[values$V2>0&values$V2<2],p.coords$y[values$V2>0&values$V2<2],p.coords$z[values$V2>0&values$V2<2],labels=values$V2[values$V2>0&values$V2<2])
dims <- par("usr")
x <- dims[1]+ xadj*diff(dims[1:2])
y <- dims[3]+ yadj*diff(dims[3:4])
text(x,y,labels[2],srt=angle+4,font=1)
})
}



#3d Scatterplots
w=7
h=5

######################################
######################################
# 3D combined Leakiness
pdf(file="plots/3Dcombined_Leakiness.pdf",width=w,height=h)
new3Dscatterplotcolorbar(c("purple4","plum"),data,data$Leakiness,range(data$Leakiness),55,7,2,0.75,0.15)
mtext(side=3, line=-1, adj=-14.5, "A", cex=1.5)
dev.off()
######################################
######################################
# 3D combined Concentration caught in Water
pdf(file="plots/3Dcombined_ConcWater.pdf",width=w,height=h)
new3Dscatterplotcolorbar(c("darkblue","lightblue"),data,data$ConcWater,range(data$ConcWater),55,7,2,0.75,0.15)
mtext(side=3, line=-1, adj=-14.5, "B", cex=1.5)
dev.off()
######################################
######################################
# 3D combined Concentration caught in Air
pdf(file="plots/3Dcombined_ConcAir.pdf",width=w,height=h)
new3Dscatterplotcolorbar(c("red","pink"),data,data$ConcAir,range(data$ConcAir),55,7,2,0.75,0.15)
mtext(side=3, line=-1, adj=-14.5, "C", cex=1.5)
dev.off()
######################################
######################################
# 2D sliced, Re & Gap Width, Leakiness & Conc Water

pdf(file="plots/ReGW_Leak_ConcWater_ConcAir.pdf",width=12,height=4)
par(mfrow=c(1,3),cex=c(0.9),cex.lab=c(0.9))

values<-data.frame(data$Re,data$GapWidth,data$Leakiness)
names(values)<-c("V1","V2","V3")
labels<-c("Re","Gap Width","Leakiness","")
new3Dscatterplot(c("green","purple"),values,labels,55,3,0.85,0.15)

values<-data.frame(data$Re,data$GapWidth,data$ConcWater)
names(values)<-c("V1","V2","V3")
labels<-c("Re","Gap Width","Conc Water","")
new3Dscatterplot(c("green","blue"),values,labels,55,2,0.85,0.15)

values<-data.frame(data$GapWidth,data$Re,data$ConcAir)
names(values)<-c("V1","V2","V3")
labels<-c("Gap Width","Re","Conc Air","")
new3Dscatterplot(c("green","blue"),values,labels,55,2,0.85,0.15)

dev.off()

######################################
######################################
# 2D sliced, Re & Gap Width, Leakiness & Conc Water
pdf(file="plots/3D_ShearHair1.pdf",width=w,height=h)
new3Dscatterplotcolorbar(c("green","orange"),data,data$ShearHair1,c(min(data$ShearHair1),max(data$ShearHair2)),55,7,2,0.75,0.15)
mtext(side=3, line=-1, adj=-14.5, "A", cex=1.5)
dev.off()

pdf(file="plots/3D_ShearHair1.pdf",width=w,height=h)
new3Dscatterplotcolorbar(c("blue","yellow"),data,data$ShearHair1,c(min(data$ShearHair1),max(data$ShearHair2)),55,7,2,0.75,0.15)
mtext(side=3, line=-1, adj=-14.5, "A", cex=1.5)
dev.off()
pdf(file="plots/3D_ShearHair2.pdf",width=w,height=h)
new3Dscatterplotcolorbar(c("blue","yellow"),data,data$ShearHair2,c(min(data$ShearHair1),max(data$ShearHair2)),55,7,2,0.75,0.15)
mtext(side=3, line=-1, adj=-14.5, "B", cex=1.5)
dev.off()
pdf(file="plots/3D_ShearHair3.pdf",width=w,height=h)
new3Dscatterplotcolorbar(c("blue","yellow"),data,data$ShearHair3,c(min(data$ShearHair1),max(data$ShearHair2)),55,7,2,0.75,0.15)
mtext(side=3, line=-1, adj=-15.5, "C", cex=1.5)
dev.off()

######################################
######################################
# 2D sliced, Re & Gap Width, Leakiness & Conc Water

pdf(file="plots/3D_UmeanHair1.pdf",width=w,height=h)
new3Dscatterplotcolorbar(c("red","yellow"),data,data$UmeanHair1,c(min(data$UmeanHair1),max(data$UmeanHair1)),55,7,2,0.75,0.15)
mtext(side=3, line=-1, adj=-14.5, "A", cex=1.5)
dev.off()
pdf(file="plots/3D_UmeanHair2.pdf",width=w,height=h)
new3Dscatterplotcolorbar(c("red","yellow"),data,data$UmeanHair2,c(min(data$UmeanHair1),max(data$UmeanHair1)),55,7,2,0.75,0.15)
mtext(side=3, line=-1, adj=-14.5, "B", cex=1.5)
dev.off()
pdf(file="plots/3D_UmeanHair3.pdf",width=w,height=h)
new3Dscatterplotcolorbar(c("red","yellow"),data,data$UmeanHair3,c(min(data$UmeanHair1),max(data$UmeanHair1)),55,7,2,0.75,0.15)
mtext(side=3, line=-1, adj=-15.5, "C", cex=1.5)
dev.off()


######################################
######################################
# 2D sliced, Re & Angle, Leakiness & Conc Water

pdf(file="plots/ReAngle_Leak_ConcWater.pdf",width=8.5,height=3.55)
par(mfrow=c(1,2),cex=c(0.9),cex.lab=c(0.9))

values<-data.frame(data$Angle,data$Re,data$Leakiness)
names(values)<-c("V1","V2","V3")
labels<-c("Angle","Re","Leakiness","")
new3Dscatterplot(c("yellow","red"),values,labels,55,3,0.85,0.15)

values<-data.frame(data$Angle,data$Re,data$ConcWater)
names(values)<-c("V1","V2","V3")
labels<-c("Angle","Re","Conc captured in water","")
new3Dscatterplot(c("green","purple"),values,labels,55,3,0.85,0.15)

dev.off()

######################################
######################################

pdf(file="plots/ReAngle_Leak_Concs.pdf",width=4.5,height=10)
par(mfrow=c(3,1),cex=c(0.9),cex.lab=c(0.9))

values<-data.frame(data$Angle,data$Re,data$Leakiness)
names(values)<-c("V1","V2","V3")
labels<-c("Angle","Re","Leakiness","")
new3Dscatterplot(c("yellow","red"),values,labels,55,3,0.85,0.15)

values<-data.frame(data$Angle,data$Re,data$ConcWater)
names(values)<-c("V1","V2","V3")
labels<-c("Angle","Re","Conc captured in Water","")
new3Dscatterplot(c("green","purple"),values,labels,55,3,0.85,0.15)

values<-data.frame(data$Angle,data$Re,data$ConcAir)
names(values)<-c("V1","V2","V3")
labels<-c("Angle","Re","Conc captured in Air","")
new3Dscatterplot(c("blue","yellow"),values,labels,55,3,0.85,0.15)


dev.off()

######################################
######################################
## Publication Ready
pdf(file="plots/GapWidthRe_Leak_Concs.pdf",width=4.5,height=10)
par(mfrow=c(3,1),cex=c(0.9),cex.lab=c(0.9))

values<-data.frame(data$GapWidth,data$Re,data$Leakiness)
names(values)<-c("V1","V2","V3")
labels<-c("Gap Width","Re","Leakiness","")
new3Dscatterplot(c("yellow","red"),values,labels,55,3,0.85,0.11)

values<-data.frame(data$GapWidth,data$Re,data$ConcWater)
names(values)<-c("V1","V2","V3")
labels<-c("Gap Width","Re","Conc captured in Water","")
new3Dscatterplot(c("purple","green"),values,labels,55,3,0.85,0.11)

values<-data.frame(data$GapWidth,data$Re,data$ConcAir)
names(values)<-c("V1","V2","V3")
labels<-c("Gap Width","Re","Conc captured in Air","")
new3Dscatterplot(c("blue","yellow"),values,labels,55,3,0.85,0.11)

dev.off()

######################################
######################################

pdf(file="plots/ReGapWidth_Leak_Concs.pdf",width=5,height=10)
par(mfrow=c(3,1),mar=c(0,0,0,0),cex=c(0.9),cex.lab=c(0.9))

values<-data.frame(data$Re,data$GapWidth,data$Leakiness)
names(values)<-c("V1","V2","V3")
labels<-c("Re","Gap Width","Leakiness","")
new3Dscatterplot(c("yellow","red"),values,labels,65,3,0.85,0.12)

values<-data.frame(data$Re,data$GapWidth,data$ConcWater)
names(values)<-c("V1","V2","V3")
labels<-c("Re","Gap Width","Conc captured in Water","")
new3Dscatterplot(c("green","purple"),values,labels,65,3,0.85,0.15)

values<-data.frame(data$Re,data$GapWidth,data$ConcAir)
names(values)<-c("V1","V2","V3")
labels<-c("Re","Gap Width","Conc captured in Air","")
new3Dscatterplot(c("blue","yellow"),values,labels,65,3,0.85,0.12)

dev.off()

######################################
######################################

pdf(file="plots/2DBoth_Air.pdf",width=8.5,height=3.5)
par(mfrow=c(1,2),cex=c(0.9),cex.lab=c(0.9))

values<-data.frame(data$Angle,data$Re,data$ConcAir)
names(values)<-c("V1","V2","V3")
labels<-c("Angle","Re","Conc captured in Air","")
new3Dscatterplot(c("blue","yellow"),values,labels,58,4,0.85,0.15)

values<-data.frame(data$GapWidth,data$Re,data$ConcAir)
names(values)<-c("V1","V2","V3")
labels<-c("Gap Width","Re","Conc captured in Air","")
new3Dscatterplot(c("blue","yellow"),values,labels,58,4,0.87,0.15)

dev.off()

pdf(file="plots/2DBoth_Water.pdf",width=8.5,height=3.55)
par(mfrow=c(1,2),cex=c(0.9),cex.lab=c(0.9))

values<-data.frame(data$Re,data$Angle,data$ConcWater)
names(values)<-c("V1","V2","V3")
labels<-c("Re","Angle","Conc captured in Water","")
new3Dscatterplot(c("green","purple"),values,labels,58,3,0.87,0.15)

values<-data.frame(data$Re,data$GapWidth,data$ConcWater)
names(values)<-c("V1","V2","V3")
labels<-c("Re","Gap Width","Conc captured in Water","")
new3Dscatterplot(c("green","purple"),values,labels,58,3,0.87,0.15)

dev.off()
######################################
######################################
# All together
pdf(file="plots/2D_AirandWater.pdf",width=8.5,height=3.5)
par(mfrow=c(1,2),cex=c(0.9),cex.lab=c(0.9))

values<-data.frame(data$Re,data$Angle,data$ConcWater*1e5)
names(values)<-c("V1","V2","V3")
labels<-c("Re","Angle","Conc. Captured in Water","")
new3Dscatterplot(c("darkblue","lightblue"),values,labels,58,3,0.9,0.13)
#values<-data.frame(data$Angle,data$Re,data$ConcAir)
#names(values)<-c("V1","V2","V3")
#labels<-c("Angle","Re","Conc captured in Air","")
#new3Dscatterplot(c("red","pink"),values,labels,58,4,0.84,0.14)

#values<-data.frame(data$Re,data$GapWidth,data$ConcWater)
#names(values)<-c("V1","V2","V3")
#labels<-c("Re","Gap Width","Conc Captured in Water","")
#new3Dscatterplot(c("darkblue","lightblue"),values,labels,58,3,0.87,0.15)

values<-data.frame(data$GapWidth,data$Angle,data$ConcAir)
names(values)<-c("V1","V2","V3")
labels<-c("Gap Width","Angle","Conc. captured in Air","")
new3Dscatterplot(c("red","pink"),values,labels,58,4,0.9,0.11)
mtext(side=3, line=-1, adj=-1.25, "A", cex=1.2)
mtext(side=3, line=-1, adj=-0.1, "B", cex=1.2)
mtext(side=3, line=-2.85, adj=-1.28, expression(x10^-5), cex=0.8)
dev.off()
######################################
######################################

pdf(file="plots/2D_ConcWater.pdf",width=8.5,height=4)
par(mfrow=c(1,2),cex=c(0.9),cex.lab=c(0.9))

values<-data.frame(data$Re,data$Angle,data$ConcWater)
names(values)<-c("V1","V2","V3")
labels<-c("Re","Angle","Conc. Captured in Water","")
new3Dscatterplot(c("darkblue","lightblue"),values,labels,58,3,0.87,0.15)

values<-data.frame(data$Re,data$GapWidth,data$ConcWater)
names(values)<-c("V1","V2","V3")
labels<-c("Re","Gap Width","Conc. Captured in Water","")
new3Dscatterplot(c("darkblue","lightblue"),values,labels,58,3,0.87,0.15)

dev.off()

######################################
######################################

# Other plots

pdf(file="plots/Leak_Water_1D.pdf",width=5,height=3.5)
par(mar = c(4,4,0.5,5))
plot(Leakiness~Re,data=data,col="black",ylab="Leakiness",xlab="Reynolds number",pch=20)
par(new=T)
plot(ConcWater~Re,data=data,col="blue",xlab="",ylab="",yaxt='n',pch=21)
axis(side=4)
mtext(side=4, line=3, "Concentration Captured in Water")
mtext(side=3, line=-1, adj=-0.23, "A", cex=1.5)
#legend("topleft", legend=c("Leakiness","Concentration in Water"),pch=c(20,21),col=c("black","blue"),cex=c(0.75))
dev.off()

pdf(file="plots/Leak_Air_1D.pdf",width=5,height=3.5)
par(mar = c(4,4,0.5,5))
plot(Leakiness~Re,data=data,col="black",ylab="Leakiness",xlab="Reynolds number",pch=20)
par(new=T)
plot(ConcAir~Re,data=data,col="red",xlab="",ylab="",yaxt='n',pch=21)
axis(side=4)
mtext(side=4, line=3, "Concentration Captured in Air")
mtext(side=3, line=-1, adj=-0.23, "B", cex=1.5)
#legend("topleft", legend=c("Leakiness","Concentration in Air"),pch=c(20,20),col=c("black","red"),cex=c(0.75))
dev.off()

######################################
######################################
# Big scatter plot with color bars at bottom



## This is a really nice figure. 
pdf(file="plots/2D_UmeanShear.pdf",width=7,height=9.5)
layout(matrix(c(1,2,3,4,5,6,7,8),nrow=4,ncol=2, byrow=TRUE),widths=c(4,4,4,4),heights=c(3,3,3,1))
new3Dscatterplot2(c("red","yellow"),data,data$UmeanHair1,c(0,120),55,7,2,0.75,0.15)
mtext(side=3, line=-2.5, adj=-0, "A", cex=1.2)
new3Dscatterplot2(c("blue","yellow"),data,data$ShearHair1,c(0,35),55,7,2,0.75,0.15)
mtext(side=3, line=-2.5, adj=-0, "D", cex=1.2)
new3Dscatterplot2(c("red","yellow"),data,data$UmeanHair2,c(0,120),55,7,2,0.75,0.15)
mtext(side=3, line=-2.5, adj=-0, "B", cex=1.2)
new3Dscatterplot2(c("blue","yellow"),data,data$ShearHair2,c(0,35),55,7,2,0.75,0.15)
mtext(side=3, line=-2.5, adj=-0, "E", cex=1.2)
new3Dscatterplot2(c("red","yellow"),data,data$UmeanHair3,c(0,120),55,7,2,0.75,0.15)
mtext(side=3, line=-2.5, adj=-0, "C", cex=1.2)
new3Dscatterplot2(c("blue","yellow"),data,data$ShearHair3,c(0,35),55,7,2,0.75,0.15)
mtext(side=3, line=-2.5, adj=-0, "F", cex=1.2)
cb1<-color.bar2(c("red","yellow"),data$UmeanHair1,c(0,120),nticks=7,3)
cb2<-color.bar2(c("blue","yellow"),data$ShearHair1,c(0,35),nticks=8,2)
dev.off()

