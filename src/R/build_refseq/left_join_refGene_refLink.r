setwd("E:\\limeng\\splicingSNP\\miso_events")

library(dplyr)
refGene_tbl<-read.table("refGene_hg19.tsv",header=FALSE,as.is=TRUE)
refLink_tbl<-read.table("reflink_map.tsv",header=FALSE,as.is=TRUE,fill=TRUE)

refGene_ret<-left_join(refGene_tbl,refLink_tbl,by=c("V4"="V1") );

refGene_ret<-refGene_ret[!is.na(refGene_ret[,1]),];

refGene_ret_sort<-refGene_ret[order(refGene_ret[,1],refGene_ret[,2],decreasing=FALSE),];

write.table(refGene_ret_sort,file="refGene_extern_hg19.bed",col.names=FALSE,row.names=FALSE,quote=FALSE,sep="\t");

