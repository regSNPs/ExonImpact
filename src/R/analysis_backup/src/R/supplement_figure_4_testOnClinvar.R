library(randomForest);
library(dplyr);
library(plyr);
library(ggplot2);

#splicing site in benign
#http://tools.genes.toronto.edu/results/0a790658-cf79-48ab-a3d9-7e68c824c90e
clinvar_benign_indel_data<-read_csv("data/clinvar/benign_indel/benign_indel_transcript_exon_id_features",col_names=TRUE);
clinvar_pathogenic_indel_data<-read_csv("data/clinvar/pathogenic_indel/pathogenic_indel_transcript_exon_id_features",
                                        col_names=TRUE);

clinvar_benign_indel_data<-clinvar_benign_indel_data[!is.na(clinvar_benign_indel_data[,"ss_1"]),]
clinvar_pathogenic_indel_data<-clinvar_pathogenic_indel_data[!is.na(clinvar_pathogenic_indel_data[,"ss_1"]),]

cat(paste0("Size of clinvar benign indel is:",nrow(clinvar_benign_indel_data) ,"\n"),
    file="result/log.txt" ,append=TRUE) ;
cat(paste0("Size of clinvar pathogenic indel is:",nrow(clinvar_pathogenic_indel_data),"\n" ),
    file="result/log.txt" ,append=TRUE) ;

clinvar_exon_ids<-c(clinvar_benign_indel_data[,"exon_id"],clinvar_pathogenic_indel_data[,"exon_id"]);

all_data_no_exclude_clinvar<-all_data_no_na[!is.element(all_data_no_na[,"exon_id"],clinvar_exon_ids),];
all_data_no_exclude_clinvar_filter<-all_data_no_exclude_clinvar[,feature_names];

model_randomForest_exlude_clinvar<-randomForest(formula=label~.,
                                   data=all_data_no_exclude_clinvar_filter,
                                   ntree=100,mtry=12,proximity=TRUE,
                                   replace=FALSE,nodesize=19); 

predict_clinvar_indel_benign<-predict(model_randomForest_exlude_clinvar,
                                      clinvar_benign_indel_data,type="prob")[,1]; 
predict_clinvar_indel_pathogenic<-predict(model_randomForest_exlude_clinvar,
                                          clinvar_pathogenic_indel_data,type="prob")[,1]; 

cat(paste0("wilcoxin test between clinvar being and pathogenic indels' FIS is: ",
           wilcox.test(predict_clinvar_indel_benign,predict_clinvar_indel_pathogenic) ,"\n"),
    file="result/log.txt" ,append=TRUE);

cat(paste0("number of exon in clinvar indel benign: ",
           nrow(clinvar_benign_indel_data) ,"\n"),file="result/log.txt",append=TRUE);
cat(paste0("number of exon in clinvar indel pathogenic: ",
           nrow(clinvar_pathogenic_indel_data) ,"\n"),file="result/log.txt",append=TRUE);

cat(paste0("number of exon in clinvar indel benign's FIS>0.91: ",
           sum(predict_clinvar_indel_benign>0.91,na.rm = TRUE) ,"\n"),file="result/log.txt",append=TRUE);
cat(paste0("number of exon in clinvar indel pathogenic's FIS>0.91: ",
           sum(predict_clinvar_indel_pathogenic>0.91,na.rm = TRUE) ,"\n"),file="result/log.txt",append=TRUE);

cat(paste0("number of exon in clinvar indel benign's FIS>0.82: ",
           sum(predict_clinvar_indel_benign>0.82,na.rm = TRUE) ,"\n"),file="result/log.txt",append=TRUE);
cat(paste0("number of exon in clinvar indel pathogenic's FIS>0.82: ",
           sum(predict_clinvar_indel_pathogenic>0.82,na.rm = TRUE) ,"\n"),file="result/log.txt",append=TRUE);

clinvar_indel_data<-
  data.frame(value=c(predict_clinvar_indel_benign,predict_clinvar_indel_pathogenic),
                               label=c(rep("benign",length(predict_clinvar_indel_benign)) ,rep("pathogenic",length(predict_clinvar_indel_pathogenic))));
cbbPalette <- c("gray66", "gray21", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7");

p<-ggplot(clinvar_indel_data)+
  geom_histogram(aes(x=value,y=..density..,fill=label),position="dodge" )+theme_classic()+
  xlab("FIS score")+
  scale_fill_manual(values=cbbPalette)+
  theme(text=element_text(size=7))+
  ggtitle("Supplement Figre 4\n Probability density for benign and pathogenic indel exons in Clinvar");

pdf("result/Supplement Figure 4 (clinvar indel test).pdf",width=8,height=5);
print(p)
dev.off();

setEPS();
postscript("result/eps/Supplement Figure 4 (clinvar indel test).eps",width=8,height=5);
#par(mfcol=c(2,1) ,xpd=TRUE);
#hist(predict_clinvar_indel_benign,breaks=seq(0,1,0.1),main="Exons contain clinvar benign Indels",xlab="FIS");
#hist(predict_clinvar_indel_pathogenic,breaks=seq(0,1,0.1),main="Exons contain clinvar pathogenic Indels",xlab="FIS");
print(p);
dev.off();


clinvar_benign_snp_data<-read_csv("data/clinvar/clinvar_benign_snp_transcript_exon_id_features",col_names=TRUE);
clinvar_pathogenic_snp_data<-read_csv("data/clinvar/clinvar_pathogenic_snp_transcript_exon_id_features",col_names=TRUE);

predict_clinvar_snp_benign<-predict(model_randomForest_exlude_clinvar,clinvar_benign_snp_data,type="prob")[,1]; 
predict_clinvar_snp_pathogenic<-predict(model_randomForest_exlude_clinvar,clinvar_pathogenic_snp_data,type="prob")[,1]; 

cat(paste0("number of exon in clinvar snp benign: ",
           sum(!is.na(predict_clinvar_snp_benign)) ,"\n"),file="result/log.txt",append=TRUE);
cat(paste0("number of exon in clinvar snp pathogenic: ",
           sum(!is.na(predict_clinvar_snp_pathogenic)) ,"\n"),file="result/log.txt",append=TRUE);

cat(paste0("number of exon in clinvar snp benign's FIS>0.91: ",
           sum(predict_clinvar_snp_benign>0.91,na.rm = TRUE) ,"\n"),file="result/log.txt",append=TRUE);
cat(paste0("number of exon in clinvar snp pathogenic's FIS>0.91: ",
           sum(predict_clinvar_snp_pathogenic>0.91,na.rm = TRUE) ,"\n"),file="result/log.txt",append=TRUE);



