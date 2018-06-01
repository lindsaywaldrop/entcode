## Loads required libraries
library(ggplot2)
library(scatterplot3d)


# Clears any previous data
rm(list=ls())


setwd("/Users/Bosque/Dropbox/EntIBAMR/results/")	# Sets directory to main



labels<-c("Angle", "Gap Width", "Re", "Angle & Gap Width", "Angle & Re", "Gap Width & Re", "All parameters")

# data from Yanyan's graph: leakiness
Uxmean1.sobol<-c(0.8518,0.00005164,0.1384,0.0004406,0.008817,1.657e-5,2.17e-9)
Uxmean1.data<-data.frame(labels,Uxmean1.sobol)
names(Uxmean1.data)<-c("x","sobol")
Uxmean2.sobol<-c(0.1096,0.00419,0.7359,0.1487,0.0007458,7.87e-5,0.0007887)
Uxmean2.data<-data.frame(labels,Uxmean2.sobol)
names(Uxmean2.data)<-c("x","sobol")
Uxmean3.sobol<-c(0.1096,0.004224,0.736,0.1486,0.0007507,7.834e-5,0.000788)
Uxmean3.data<-data.frame(labels,Uxmean3.sobol)
names(Uxmean3.data)<-c("x","sobol")

shearhair1.sobol<-c(0.4982,0.004762,0.4887,0.004586,0.003524,0.002707,7.842e-8)
shearhair1.data<-data.frame(labels,shearhair1.sobol)
names(shearhair1.data)<-c("x","sobol")
shearhair2.sobol<-c(0.8493,0.004868,0.1179,0.01338,0.01433,6.686e-5,0.00001973)
shearhair2.data<-data.frame(labels,shearhair2.sobol)
names(shearhair2.data)<-c("x","sobol")
shearhair3.sobol<-c(0.8445,0.006058,0.1156,0.0223,0.01122,9.702e-5,0.0001606)
shearhair3.data<-data.frame(labels,shearhair3.sobol)
names(shearhair3.data)<-c("x","sobol")

leakiness.sobol<-c(0.06862,0.01506,0.8621,0.0317,0.02137,0.0006241,0.0005195)
leakiness.data<-data.frame(labels,leakiness.sobol)
names(leakiness.data)<-c("x","sobol")

#concwater.sobol<-c(0.1367,0.0006055,0.8495,0.001812,0.01119,8.19e-5,4.638e-5) #OLD INDICES
concwater.sobol<-c(0.114317128252430,0.000520105787705,0.880479935787527,0.000275201357213,0.004339853324948,0.000064095569462,0.000003679920717)  #NEW INDICES 5/28/2018
concwater.data<-data.frame(labels,concwater.sobol)
names(concwater.data)<-c("x","sobol")
concair.sobol<-c(0.1599,0.833,2.367e-5,0.00705,3.788e-6,1.684e-6,3.34e-11)
concair.data<-data.frame(labels,concair.sobol)
names(concair.data)<-c("x","sobol")

cbPalette1 <- c("#999999", "#E69F00", "#56B4E9")#, "#009E73")
cbPalette2<-c("#F0E442", "#0072B2", "#D55E00")#, "#CC79A7")

##############################################################################################
##############################################################################################

simplesobolplot<-function(data,c1){
ggplot(data, aes(x=x,y=sobol,fill=TRUE),labs=(x=NULL),xlab="") + 
  scale_y_continuous("Sobol Indices",limits=c(0,1),expand=c(0,0)) +
  scale_x_discrete("",labels=labels,limits=labels) +
  theme_bw(base_size = 16) + 
  theme(axis.text.x=element_text(angle=45,hjust=1),legend.position="none") +
  geom_bar(stat='identity') +  scale_fill_manual(values=c1)
  }

pdf(file="plots/Sobol_UmeanHair1.pdf",width=4.25,height=3.5)
simplesobolplot(Uxmean1.data,c("purple4"))
dev.off()
pdf(file="plots/Sobol_UmeanHair2.pdf",width=4.25,height=3.5)
simplesobolplot(Uxmean2.data,c("purple4"))
dev.off()
pdf(file="plots/Sobol_UmeanHair3.pdf",width=4.25,height=3.5)
simplesobolplot(Uxmean3.data,c("purple4"))
dev.off()

pdf(file="plots/Sobol_ShearHair1.pdf",width=4.25,height=3.5)
simplesobolplot(shearhair1.data,c("purple4"))
dev.off()
pdf(file="plots/Sobol_ShearHair2.pdf",width=4.25,height=3.5)
simplesobolplot(shearhair2.data,c("purple4"))
dev.off()
pdf(file="plots/Sobol_ShearHair3.pdf",width=4.25,height=3.5)
simplesobolplot(shearhair3.data,c("purple4"))
dev.off()

pdf(file="plots/Sobol_Leakiness.pdf",width=4.25,height=3.5)
simplesobolplot(leakiness.data,c("purple4"))
dev.off()

pdf(file="plots/Sobol_ConcWater.pdf",width=4.25,height=3.5)
simplesobolplot(concwater.data,c("darkblue"))
dev.off()

pdf(file="plots/Sobol_ConcAir.pdf",width=4.25,height=3.5)
simplesobolplot(concair.data,c("red"))
dev.off()



##############################################################################################
##############################################################################################

# Define new plotting funtion
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}



newsobolplot2<-function(data1,data2,types,labels,colors,spot){
	x<-c(rep(labels,2))
	y<-c(data1$sobol,data2$sobol)
	typelabels<-c(rep(types[1],length(data1$x)),rep(types[2],length(data2$x)))
	plotdata<-data.frame(x,y,typelabels)
	plotdata$typelabels<-factor(plotdata$typelabels,levels=types)
	ggplot(plotdata, aes(x=x,y=y,fill=typelabels),labs=(x=NULL),xlab="") + 
	scale_y_continuous("Sobol Indices",limits=c(0,1),expand=c(0,0)) + scale_x_discrete("",labels=labels,limits=labels) + 
	theme_bw(base_size = 16) + 
	theme(axis.text.x=element_text(angle=45,hjust=1),legend.direction="horizontal",legend.position=c(0.5,1.15),
  		legend.background = element_rect(fill=alpha('white', 0))) + geom_bar(stat='identity',position=position_dodge()) + 
  		guides(fill=guide_legend(title=" ")) + scale_fill_manual(values=colors,labels=types) + 
  		ggtitle(spot) + theme(plot.title=element_text(hjust=-0.22))
  }
  
  
newsobolplot3<-function(data1,data2,data3,types,labels,colors,spot){
	x<-c(rep(labels,3))
	y<-c(data1$sobol,data2$sobol,data3$sobol)
	typelabels<-c(rep(types[1],length(data1$x)),rep(types[2],length(data2$x)),rep(types[3],length(data3$x)))
	plotdata<-data.frame(x,y,typelabels)
	plotdata$typelabels<-factor(plotdata$typelabels,levels=types)
	ggplot(plotdata, aes(x=x,y=y,fill=typelabels),labs=(x=NULL),xlab="") + 
	scale_y_continuous("Sobol Indices",limits=c(0,1),expand=c(0,0)) + scale_x_discrete("",labels=labels,limits=labels) + 
	theme_bw(base_size = 16) + 
	theme(axis.text.x=element_text(angle=45,hjust=1),legend.direction="horizontal",legend.position=c(0.5,1.15),
  		legend.background = element_rect(fill=alpha('white', 0))) + geom_bar(stat='identity',position=position_dodge()) + 
  		guides(fill=guide_legend(title=" ")) + scale_fill_manual(values=colors,labels=types) + 
  		ggtitle(spot) + theme(plot.title=element_text(hjust=-0.22))
  }


pdf(file="plots/Sobol_LeakinessWater.pdf",width=4.5,height=3.5)
newsobolplot2(leakiness.data,concwater.data,c("Leakiness","Conc. in Water"),labels,c("purple4","steelblue"),c("C"))
dev.off()
pdf(file="plots/Sobol_LeakinessAir.pdf",width=4.5,height=3.5)
newsobolplot2(leakiness.data,concair.data,c("Leakiness","Conc. in Air"),labels,c("purple4","red"),c("D"))
dev.off()

pdf(file="plots/Sobol_Umean.pdf",width=4.5,height=3.5)
newsobolplot3(Uxmean1.data,Uxmean2.data,Uxmean3.data,c("Center hair", "Top hair", "Bottom hair"),labels,cbPalette2,c("A"))
dev.off()
pdf(file="plots/Sobol_Shear.pdf",width=4.5,height=3.5)
newsobolplot3(shearhair1.data,shearhair2.data,shearhair3.data,c("Center hair", "Top hair", "Bottom hair"),labels,cbPalette2,c("B"))
dev.off()

##############################################################################################




##############################################################################################
##############################################################################################
##############################################################################################
