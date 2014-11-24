x=read.csv("thermal2_diffexp_withvals.csv")
x2=data.matrix(x[1:100,3:8]) #select table to plot

palette = colorRampPalette(c("black","green","white"))(n=299) #set up color palette

heatmap(x2,palette,scale="none")

heatmap.2(x2,col=palette,scale="none",trace="none") #part of the gplots package
