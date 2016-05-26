setwd("/Users/mengli/Documents/splicingSNP_new/");
source("src/R/supplement_figure_4_testOnClinvar.R");

clinvar_benign_snp_data<-read_csv("data/clinvar/clinvar_benign_snp_transcript_exon_id_features",col_names=TRUE);
clinvar_pathogenic_snp_data<-read_csv("data/clinvar/clinvar_pathogenic_snp_transcript_exon_id_features",col_names=TRUE);

predict_clinvar_snp_benign<-predict(model_randomForest_exlude_clinvar,clinvar_benign_snp_data,type="prob")[,1]; 
predict_clinvar_snp_pathogenic<-predict(model_randomForest_exlude_clinvar,clinvar_pathogenic_snp_data,type="prob")[,1]; 


flog.info(paste0("number of exon in clinvar snp benign: ",
           sum(!is.na(predict_clinvar_snp_benign)) ) );
flog.info(paste0("number of exon in clinvar snp pathogenic: ",
           sum(!is.na(predict_clinvar_snp_pathogenic)) ));

flog.info(paste0("number of exon in clinvar snp benign's FIS>0.91: ",
           sum(predict_clinvar_snp_benign>0.91,na.rm = TRUE) ) );
flog.info(paste0("number of exon in clinvar snp pathogenic's FIS>0.91: ",
           sum(predict_clinvar_snp_pathogenic>0.91,na.rm = TRUE) ) );

