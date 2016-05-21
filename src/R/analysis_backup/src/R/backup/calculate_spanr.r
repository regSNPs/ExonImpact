
a1000_genome_fis<-read_csv("data/1000_genome_MAF5/1000_genome_MAF5_splicingJunction20_transcript_exon_id_features",
                           col_names = TRUE);
a1000_genome_fis_data<-as.data.frame(a1000_genome_fis);

a1000_genome_fis_data<-a1000_genome_fis_data[!is.na(a1000_genome_fis_data[,"ss_1"]),];

a1000_genome_dpsi<-read_tsv("data/1000_genome_MAF5/transcript_exon_id_dpsi_mapping.tsv",col_names = TRUE);
a1000_genome_dpsi_data<-as.data.frame(a1000_genome_dpsi);

a1000_genome_fis_dpsi<-inner_join(a1000_genome_fis_data,a1000_genome_dpsi_data,by=c("exon_id"="transcript_exon_id") );

predict_1000_genome_fis<-predict(modelrandomforestAll,a1000_genome_fis_dpsi,type="prob")[,1]; 

a1000_genome_fis_dpsi<-cbind(a1000_genome_fis_dpsi,predict_1000_genome_fis);

a1000_genome_fis_dpsi_select<-a1000_genome_fis_dpsi[,c("exon_id","predict_1000_genome_fis","dpsi") ];
colnames(a1000_genome_fis_dpsi_select)<-c("exon_id","fis","dpsi");

a1000_genome_fis_dpsi_select_20<-subset(a1000_genome_fis_dpsi_select,abs(dpsi)>20);

a1000_genome_fis_dpsi_select_10_20<-subset(a1000_genome_fis_dpsi_select,abs(dpsi)<20&abs(dpsi)>10);

a1000_genome_fis_dpsi_select_10<-subset(a1000_genome_fis_dpsi_select,abs(dpsi)<10);


percent_dpsi_20<-
  sum(a1000_genome_fis_dpsi_select_20[,"fis"]>0.91,na.rm=TRUE)/sum(!is.na(a1000_genome_fis_dpsi_select_20[,"fis"]));
percent_dpsi_10_20<-
  sum(a1000_genome_fis_dpsi_select_10_20[,"fis"]>0.91,na.rm=TRUE)/sum(!is.na(a1000_genome_fis_dpsi_select_10_20[,"fis"]));
percent_dpsi_10<-
  sum(a1000_genome_fis_dpsi_select_10[,"fis"]>0.91,na.rm=TRUE)/sum(!is.na(a1000_genome_fis_dpsi_select_10[,"fis"]));


cat(paste0("percent of fis>0.91 for |dpsi|>20 is: ",percent_dpsi_20,"\n"),file="result/log.txt",append=TRUE);
cat(paste0("percent of fis>0.91 for 20>|dpsi|>10 is: ",percent_dpsi_10_20,"\n"),file="result/log.txt",append=TRUE);
cat(paste0("percent of fis>0.91 for |dpsi|<10 is: ",percent_dpsi_10,"\n"),file="result/log.txt",append=TRUE);

