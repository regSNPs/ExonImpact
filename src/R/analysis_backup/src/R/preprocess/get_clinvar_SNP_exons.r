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

benign_transcripts<-str_match(clinvar_benign_snp_data[,"X8"],
                              'Func.ensGene=splicing[^;]*;Gene.ensGene=[^;]*;GeneDetail.ensGene=(ENST[^:]+:exon[^:]+)'); 
benign_transcripts_noNa<-benign_transcripts[!is.na(benign_transcripts)];

cat(paste0("Number of beign SNPs is ",length(benign_transcripts_noNa),"\n" ),file="result/log.txt",append=TRUE);

benign_transcripts_noNa_half<-benign_transcripts_noNa[(length(benign_transcripts_noNa)/2+1):length(benign_transcripts_noNa)];
benign_transcripts_noNa_half_transcript_exon_id<-
  str_c(str_sub(benign_transcripts_noNa_half,1,15),":",str_sub(benign_transcripts_noNa_half,21) );

cat(benign_transcripts_noNa_half_transcript_exon_id,file="data/clinvar/clinvar_benign_snp_transcript_exon_id",sep="\n");

#clinvar_pathogenic_transcript_id<-gsub("Func.ensGene=splicing[^;]*;Gene.ensGene=[^;]*;GeneDetail.ensGene=([^;]*);",
#"\\1",clinvar_pathogenic_snp_data[,"X8"]); 

pathogenic_transcripts<-str_match(clinvar_pathogenic_snp_data[,"X8"],
                                  'Func.ensGene=splicing[^;]*;Gene.ensGene=[^;]*;GeneDetail.ensGene=(ENST[^:]+:exon[^:]+)'); 
pathogenic_transcripts_noNa<-pathogenic_transcripts[!is.na(pathogenic_transcripts)];

cat(paste0("Number of pathogenic SNPs is ",length(pathogenic_transcripts_noNa),"\n" ),file="result/log.txt",append=TRUE);


pathogenic_transcripts_noNa_half<-
  pathogenic_transcripts_noNa[(length(pathogenic_transcripts_noNa)/2+1):length(pathogenic_transcripts_noNa)];

pathogenic_transcripts_noNa_half_transcript_exon_id<-
  str_c(str_sub(pathogenic_transcripts_noNa_half,1,15),":",str_sub(pathogenic_transcripts_noNa_half,21) );

cat(pathogenic_transcripts_noNa_half_transcript_exon_id,
    file="data/clinvar/clinvar_pathogenic_snp_transcript_exon_id",sep="\n");


###parse clinvar benign intronic and synonymous.
#extract SNP in splicing site, intronic and synonymous.
clinvar_benign_snp_data_label<-grepl("(ExonicFunc.ensGene=synonymous_SNV)|(Func.ensGene=intronic)|(Func.ensGene=splicing)",
                                     clinvar_benign_snp_data[,"X8"]);

clinvar_benign_snp_data_vcf<-clinvar_benign_snp_data[clinvar_benign_snp_data_label,];
clinvar_benign_snp_data_vcf[,"X1"]<-str_c("chr",clinvar_benign_snp_data_vcf[,"X1"]);
write.table(clinvar_benign_snp_data_vcf,file="data/clinvar/clinvar_benign_intronic_synonymous_splicing_data.vcf"
            ,sep="\t",quote=FALSE,row.names = FALSE,col.names = FALSE);

clinvar_benign_snp_data_vcf_spanr<-str_c("chr",clinvar_benign_snp_data_vcf[,1],":",
                                         clinvar_benign_snp_data_vcf[,2],"-",clinvar_benign_snp_data_vcf[,2])

cat(clinvar_benign_snp_data_vcf_spanr,file="data/clinvar/clinvar_intron_synonymous_spanr",sep="\n");

#need SPANR to get the dpsi of each position.
clinvar_benign_snp_data_vcf_dpsi<-read.table("data/clinvar/clinvar_intron_synonymous_spanr.dpsi",
                                             header=FALSE,sep="\t",as.is=TRUE);

#join the clinvar benign and dpsi.
clinvar_benign_snp_data_vcf_dpsi_join_snp<-inner_join(clinvar_benign_snp_data_vcf,
                                                  clinvar_benign_snp_data_vcf_dpsi,
                                                  by=c("X1"="V1","X2"="V2","X4"="V3","X5"="V4") );

clinvar_benign_snp_data_vcf_dpsi_join_snp<-
  clinvar_benign_snp_data_vcf_dpsi_join_snp[abs(clinvar_benign_snp_data_vcf_dpsi_join_snp[,"V5"])>=20,c("X1","X2","V9","V10")];


clinvar_benign_snp_data_vcf_indel<-clinvar_benign_snp_data_vcf[(nchar(clinvar_benign_snp_data_vcf[,"X5"])>1),];

clinvar_benign_snp_data_vcf_dpsi_join_indel<-inner_join(clinvar_benign_snp_data_vcf_indel,
                                                  clinvar_benign_snp_data_vcf_dpsi,by=c("X1"="V1","X2"="V2") );

clinvar_benign_snp_data_vcf_dpsi_join_indel<-
  clinvar_benign_snp_data_vcf_dpsi_join_indel[abs(clinvar_benign_snp_data_vcf_dpsi_join_indel[,"V5"])>=20,c("X1","X2","V9","V10")];

clinvar_benign_snp_data_vcf_dpsi_join_indel_uniq<-unique(clinvar_benign_snp_data_vcf_dpsi_join_indel);

###6 SNP and 5 indels here. 
clinvar_benign_snp_data_vcf_dpsi_join_all_dpsi20<-clinvar_benign_snp_data_vcf_dpsi_join_snp;
#clinvar_benign_snp_data_vcf_dpsi_join_all_dpsi20<-rbind(clinvar_benign_snp_data_vcf_dpsi_join_snp,
#clinvar_benign_snp_data_vcf_dpsi_join_indel_uniq);

#clinvar_benign_snp_data_vcf_dpsi_join_dpsi20<-subset(clinvar_benign_snp_data_vcf_dpsi_join,abs(V5)>=20);

clinvar_benign_snp_data_vcf_dpsi_join_dpsi20_exon_id<-str_c(clinvar_benign_snp_data_vcf_dpsi_join_all_dpsi20[,"V9"],":",
                                                            clinvar_benign_snp_data_vcf_dpsi_join_all_dpsi20[,"V10"]);

cat(clinvar_benign_snp_data_vcf_dpsi_join_dpsi20_exon_id,
    file="data/clinvar/clinvar_benign_snp_data_vcf_dpsi_join_dpsi20_exon_id",sep="\n");

#cat(clinvar_benign_snp_data_vcf_dpsi_join_dpsi20_exon_id,file="clinvar_benign_snp_data_vcf_dpsi_join_dpsi20_exon_id",sep="\t");

clinvar_intron_synonymous_features<-read_csv("data/clinvar/clinvar_benign_snp_data_vcf_dpsi_join_dpsi20_exon_id_output.csv",
                                             col_names = TRUE);
clinvar_intron_synonymous_features_data<-as.data.frame(clinvar_intron_synonymous_features);

clinvar_intron_synonymous_features_data_pre<-predict(modelrandomforestAll,
                                                     clinvar_intron_synonymous_features_data,type="prob")[,1];

