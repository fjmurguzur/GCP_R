library(raster)

gcp_list<-read.delim("Data/gcp_start.txt",header=FALSE)
colnames(gcp_list)<-c("X","Y","Z","GCP_Name","img")

temp.list<-list()
for (i in 1:length(gcp_list$img)){
  asd<-brick(gcp_list$img[i])
  cat(gcp_list$GCP_Name[i])
  plotRGB(asd,r=1,g=2,b=3,stretch="lin")
  cropextent<-drawExtent()
  plot(asd[[1]],xlim=c(cropextent@xmin,cropextent@xmax),ylim=c(cropextent@ymin,cropextent@ymax))
  place<-locator(n=1)
  temp.list[[i]]<-cbind.data.frame(img=gcp_list$img[i], x_img=place$x,y_img=place$y-dim(asd)[1]) #we subtract the dim(asd)[1]. That's how ODM sees the right place...
  
}

gcp_ground<-do.call(rbind.data.frame,temp.list)

final.gcp<-merge(gcp_list,gcp_ground)

final.gcp<-final.gcp[,c(2,3,4,6,7,1,5)]

write.table(final.gcp,file="gcp_list.txt",sep="\t",row.names=F)
