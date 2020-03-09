library(stringr);
library(readr);
library(dplyr);

setwd("/Users/mengli/Documents/splicingSNP_new")
source("src/R/preprocess/parse_AAchange.r");
source("src/R/VCF.R");
source("src/R/BED.R");


###clinvar snp parse
clinvar_benign_snp<-read_tsv("data/clinvar/clinvar_ens.hg19_multianno_benign.vcf",col_names = FALSE);
clinvar_pathogenic_snp<-read_tsv("data/clinvar/clinvar_ens.hg19_multianno_pathogenic.vcf",col_names = FALSE);

clinvar_benign_snp_data<-as.data.frame(clinvar_benign_snp);
clinvar_pathogenic_snp_data<-as.data.frame(clinvar_pathogenic_snp);

##########################################parse benign############################################################
benign_transcripts<-
  str_match(clinvar_benign_snp_data[,"X8"],
                              'Func.ensGene=splicing[^;]*;Gene.ensGene=[^;]*;GeneDetail.ensGene=(ENST[^:]+:exon[^:]+)') ;
benign_transcripts_noNa<-benign_transcripts[!is.na(benign_transcripts)];
                
flog.info(paste0("Number of beign SNPs is ",length(benign_transcripts_noNa) ) );

benign_transcripts_noNa_ids<-benign_transcripts_noNa[str_detect(benign_transcripts_noNa,"^ENST.*")];
benign_transcripts_noNa_ids_transcript_exon_id<-
  str_c(str_sub(benign_transcripts_noNa_ids,1,15),":",str_sub(benign_transcripts_noNa_ids,21) );

cat(benign_transcripts_noNa_half_transcript_exon_id,
    file="clinvar_benign_snp_transcript_exon_id",sep="\t" );

 
##########################################parse pathogenic############################################################
pathogenic_transcripts<-str_match(clinvar_pathogenic_snp_data[,"X8"],
                                  'Func.ensGene=splicing[^;]*;Gene.ensGene=[^;]*;GeneDetail.ensGene=(ENST[^:]+:exon[^:]+)'); 
pathogenic_transcripts_noNa<-pathogenic_transcripts[!is.na(pathogenic_transcripts)];

flog.info(paste0("Number of pathogenic SNPs is ",length(pathogenic_transcripts_noNa)  )  );

pathogenic_transcripts_noNa_half<-pathogenic_transcripts_noNa[str_detect(pathogenic_transcripts_noNa,"^ENST.*")];

pathogenic_transcripts_noNa_half_transcript_exon_id<-
  str_c(str_sub(pathogenic_transcripts_noNa_half,1,15),":",str_sub(pathogenic_transcripts_noNa_half,21) );

cat(pathogenic_transcripts_noNa_half_transcript_exon_id,
    file="clinvar_pathogenic_snp_transcript_exon_id",sep="\t" );


