library(readr)
setwd("/Users/mengli/Documents/splicingSNP_new");

hgmd_raw_data<-read_tsv("data/hgmd_raw_data/Yunlong_HGMD_INTRONIC_SPLICING_MORT_14_2.tsv",col_names=TRUE);

subsit_char<-hgmd_raw_data[,"sub"];
subsit_char<-str_split(subsit_char,"-");

ref<-sapply(subsit_char,"[",1);
alt<-sapply(subsit_char,"[",2);

chr<-hgmd_raw_data[,"hg19_chromosome"];
pos<-hgmd_raw_data[,"hg19_coordinate"];

result<-data.frame(chr=chr,start=pos,end=pos,ref=ref,alt=alt);
write.table(result,file="data/hgmd_raw_data/hgmd_for_annovar.tsv",quote=FALSE,sep="\t",col.names = FALSE,row.names=FALSE);

