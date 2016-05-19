library(stringr)
library(dplyr)

a1000_genome_dpsi<-read_tsv("data/1000_genome_MAF5/1000_genome.splicingjunction20.maf5.hg19_multianno.spanr.dpsi"
                           ,col_names = FALSE);
colnames(a1000_genome_dpsi)[1:5]<-c("chr","pos","ref","alt","dpsi");
a1000_genome_dpsi_data<-as.data.frame(a1000_genome_dpsi);

a1000_genome_info<-read_tsv("data/1000_genome_MAF5/1000_genome.splicingjunction20.maf5.hg19_multianno.INFO",
                            col_names = TRUE);
a1000_genome_info_data<-as.data.frame(a1000_genome_info);

a1000_genome_info_data[,"CHROM"]<-str_c("chr",a1000_genome_info_data[,"CHROM"] );

a1000_genome_dpsi_info<-inner_join(a1000_genome_dpsi_data,a1000_genome_info_data,
                                   by=c("chr"="CHROM","pos"="POS","ref"="REF","alt"="ALT"));

a1000_genome_dpsi_info_filter<-a1000_genome_dpsi_info[!a1000_genome_dpsi_info[,"AAChange.ensGene"]==".",];

aa_change_split<-strsplit(a1000_genome_dpsi_info_filter[,"AAChange.ensGene"],":");
transcript_id<-sapply(aa_change_split,"[",2);
exon_id<-str_sub(sapply(aa_change_split,"[",3),5 );

transcript_exon_id<-str_c(transcript_id,":",exon_id);

a1000_genome_dpsi_info_filter_id<-cbind(a1000_genome_dpsi_info_filter,transcript_exon_id);

result<-ddply(a1000_genome_dpsi_info_filter_id,.(transcript_exon_id) ,function(x){
  dpsi_abs<-abs(x[,"dpsi"]);
  max_dpsi_abs<-max(dpsi_abs);
  #max_dpsi_abs_transcript_exon_id<-x[which.max(max_dpsi_abs),"transcript_exon_id"];
  
  return(max_dpsi_abs);
});

colnames(result)<-c("transcript_exon_id","dpsi");
write.table(result,file="data/1000_genome_MAF5/transcript_exon_id_dpsi_mapping.tsv",quote=FALSE,row.names = FALSE,sep="\t");

cat(as.character(result[,"transcript_exon_id"]),
    file="data/1000_genome_MAF5/1000_genome_MAF5_splicingJunction20_transcript_exon_id",sep="\n");

