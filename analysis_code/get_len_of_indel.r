setwd("/Users/mengli/Documents/splicingSNP_new/data/1000_genome_indel");

indels<-read.table("out.INFO",sep="\t",header=TRUE,as.is=TRUE);

indels_exon<-indels[indels[,5]!=".",];

insert_max_len<-max(nchar(indels_exon[,4]));
delete_max_len<-max(nchar(indels_exon[,3]));

insert_len<-nchar(indels_exon[,4]);
delete_len<-nchar(indels_exon[,3]);


