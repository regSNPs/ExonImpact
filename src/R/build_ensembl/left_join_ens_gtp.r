setwd("/Users/mengli/Documents/splicingSNP_new/data/build_db/")

library(dplyr)
ens_tbl<-read.table("ens_hg19.bed",header=FALSE,as.is=TRUE)
colnames(ens_tbl)[4]<-"name"
gtp_tbl<-read.table("ens_hg19.gtp",header=FALSE,as.is=TRUE,fill=TRUE);
colnames(gtp_tbl)<-c("gene","transcript","protein");

ens_ret<-left_join(ens_tbl,gtp_tbl,by=c("name"="transcript") );


ens_ret<-ens_ret[!is.na(ens_ret[,"protein"]),];

ens_ret_sort<-ens_ret[order(ens_ret[,1],ens_ret[,2],decreasing=FALSE),];

write.table(ens_ret_sort,file="ens_extern_hg19.bed",col.names=FALSE,
	row.names=FALSE,quote=FALSE,sep="\t");

