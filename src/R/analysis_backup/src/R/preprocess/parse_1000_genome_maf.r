library(stringr);
library(dplyr);

setwd("/Users/mengli/Documents/splicingSNP_new");
source("src/R/preprocess/parse_AAchange.r");

a1000_genome_dpsi<-as.data.frame(read_tsv("data/1000_genome_MAF5/1000_genome.splicingjunction20.maf5.hg19_multianno.spanr.dpsi"
                           ,col_names = FALSE) );
colnames(a1000_genome_dpsi)[1:5]<-c("chr","pos","ref","alt","dpsi");

a1000_genome_info<-as.data.frame(read_tsv("data/1000_genome_MAF5/1000_genome.splicingjunction20.maf5.hg19_multianno.INFO",
                            col_names = TRUE) );
a1000_genome_info[,"CHROM"]<-str_c("chr",a1000_genome_info[,"CHROM"] );


a1000_genome_dpsi_info<-inner_join(a1000_genome_dpsi,a1000_genome_info,
                                   by=c("chr"="CHROM","pos"="POS","ref"="REF","alt"="ALT"));
a1000_genome_dpsi_info_filter<-filter(a1000_genome_dpsi_info,AAChange.ensGene!="." );


transcript_exon_id<-parse_AAchange(a1000_genome_dpsi_info_filter[,"AAChange.ensGene"]);
a1000_genome_dpsi_info_filter_id<-cbind(a1000_genome_dpsi_info_filter,transcript_exon_id);

result<-ddply(a1000_genome_dpsi_info_filter_id,.(transcript_exon_id) ,function(x){
  dpsi_abs<-abs(x[,"dpsi"]);
  max_dpsi_abs<-max(dpsi_abs);
  return(max_dpsi_abs);
});

colnames(result)<-c("transcript_exon_id","dpsi");
write.table(result,file="data/1000_genome_MAF5/transcript_exon_id_dpsi_mapping.tsv",quote=FALSE,row.names = FALSE,sep="\t");

cat(as.character(result[,"transcript_exon_id"]),
    file="data/1000_genome_MAF5/1000_genome_MAF5_splicingJunction20_transcript_exon_id",sep="\n" );

