library(stringr);

setwd("/Users/mengli/Documents/splicingSNP_new")
source("src/R/preprocess/parse_AAchange.r");

aa_change<-readLines("data/1000_genome_indel/aa_change_uniq");
##MAF>5%
#aa_change<-readLines("data/1000_genome_indel/MAF5_indel/aa_change_indel_maf5_uniq");

transcript_exon_id_filter<-parse_AAchange(aa_change);
cat(unique(transcript_exon_id_filter),file="data/1000_genome_indel/1000_genome_transcript_exon_id",sep="\n" );

frameshift_indels<-read.table("data/1000_genome_indel/frameshift_indel/out.INFO.AA",
                              header=FALSE,as.is=TRUE);

is_frameshift<-apply(frameshift_indels,1,function(x){
  if(nchar(x["V3"])%%3==0||nchar(x["V4"])%%3==0 ){
    return(FALSE);
  }
  
  return(TRUE);
});

frameshift_aaChange<-frameshift_indels[is_frameshift,"V5"];
transcript_exon_id_frameshift<-parse_AAchange(frameshift_aaChange);
transcript_exon_id_frameshift_filter<-transcript_exon_id_frameshift[!grepl("egene",transcript_exon_id_frameshift)];
cat(unique(transcript_exon_id_frameshift_filter),
    file="data/1000_genome_indel/frameshift_indel/1000_genome_transcript_exon_id_frameshift",sep="\n" );

