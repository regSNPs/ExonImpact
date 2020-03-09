library(magrittr);
library(randomForest)
library(plyr);
library(dplyr);

library(readr);
library(ggplot2);
setwd("/Users/mengli/Documents/splicingSNP_new/");

load("result/model");

a1000_genome_fis<-read_csv("data/1000_genome_MAF5/1000_genome_MAF5_splicingJunction20_transcript_exon_id_features",
                           col_names = TRUE);
						   
#only keep the protein coding ones
a1000_genome_fis_data<-filter(a1000_genome_fis,!is.na(ss_1) );

a1000_genome_dpsi<-read_tsv("data/1000_genome_MAF5/transcript_exon_id_dpsi_mapping.tsv",col_names = TRUE);

a1000_genome_fis_dpsi<-inner_join(a1000_genome_fis_data,a1000_genome_dpsi,by=c("exon_id"="transcript_exon_id") );

predict_1000_genome_fis<-predict(modelrandomforestAll,a1000_genome_fis_dpsi,type="prob")[,1]; 


a1000_genome_fis_dpsi<-mutate(a1000_genome_fis_dpsi,predict_1000_genome_fis) %>%
	rename(fis=predict_1000_genome_fis);

pdf("result/FIS_dPSI_scatter.pdf");
qplot(a1000_genome_fis_dpsi$dpsi,a1000_genome_fis_dpsi$fis)+scale_x_log10()+xlab("dPSI")+ylab("FIS");
  
smoothScatter(a1000_genome_fis_dpsi$dpsi,a1000_genome_fis_dpsi$fis,xlab="dPSI",ylab="FIS"); 
plot(a1000_genome_fis_dpsi$dpsi,a1000_genome_fis_dpsi$fis,xlab="dPSI",ylab="FIS"); 

dev.off();


a1000_genome_fis_dpsi %<>% mutate(paste0(abs(dpsi)>20,abs(dpsi)<10) ) %>%
	rename(dpsi_group=`paste0(abs(dpsi) > 20, abs(dpsi) < 10)` );


a1000_genome_fis_dpsi_group<-ddply(a1000_genome_fis_dpsi, .(dpsi_group),function(x){
	if(x[1,"dpsi_group"]=="TRUEFALSE")
		return(c("|dpsi|>20",sum(x[,"fis"]>0.91),nrow(x)  ,sum(x[,"fis"]>0.91)/nrow(x)  ) );
	
	if(x[1,"dpsi_group"]=="FALSEFALSE")
		return(c("10<|dpsi|<20",sum(x[,"fis"]>0.91),nrow(x) ,sum(x[,"fis"]>0.91)/nrow(x)  ) );
	
	if(x[1,"dpsi_group"]=="FALSETRUE")
		return(c("|dpsi|<10",sum(x[,"dpsi_group"] >0.91),nrow(x)  ,sum(x[,"fis"]>0.91)/nrow(x)  ) );
});

fis_dpsi0<-subset(as.data.frame(a1000_genome_fis_dpsi),dpsi_group=="FALSETRUE")[,"fis"]

fis_dpsi10<-subset(as.data.frame(a1000_genome_fis_dpsi),dpsi_group=="FALSEFALSE")[,"fis"]
fis_dpsi20<-subset(as.data.frame(a1000_genome_fis_dpsi),dpsi_group=="TRUEFALSE")[,"fis"]

wilcox.test(fis_dpsi0,fis_dpsi20,alternative="greater");

a1000_genome_fis_dpsi_group %<>% rename(dpsi_group_label=V1) %>% rename(number_of_b0.91=V2) %>% 
  rename(total=V3) %>% rename(percent=V4);

flog.info(a1000_genome_fis_dpsi_group);


