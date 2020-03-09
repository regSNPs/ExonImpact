library(readr)
library(stringr)

setwd("/Users/mengli/Documents/splicingSNP_new");

hgmd_data_anno<-read_tsv("data/hgmd_raw_data/hgmd_splicing.hg19_multianno.txt",col_names = TRUE);
hgmd_data_anno<-as.data.frame(hgmd_data_anno);
#funcs<-hgmd_data_anno[,"Func.refGene"];#
hgmd_data_anno_splicing<-hgmd_data_anno[hgmd_data_anno[,"Func.ensGene"]=="splicing",];

flog.info(paste0("The number of snp in HGMD splicing site is: ",nrow(hgmd_data_anno_splicing),
           "\tevidenct: data/hgmd_raw_data/hgmd_splicing.hg19_multianno.txt") );

#AAChange.refGene
aa_change_splicing<-as.character(hgmd_data_anno_splicing[,"GeneDetail.ensGene"]);
aa_changes_split<-strsplit(aa_change_splicing,":");

transcript_id<-sapply(aa_changes_split,"[",1);
exon_id<-str_sub(sapply(aa_changes_split,"[",2) ,5);

transcript_exon_id<-str_c(transcript_id,":",exon_id);
cat(unique(transcript_exon_id),file="data/hgmd_raw_data/hgmd_transcript_exon_id",sep="\n");
