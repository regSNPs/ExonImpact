library(randomForest);
library(dplyr);
library(plyr);
library(ggplot2);

setwd("/Users/mengli/Documents/splicingSNP_new/");

#splicing site in benign
#http://tools.genes.toronto.edu/results/0a790658-cf79-48ab-a3d9-7e68c824c90e
clinvar_benign_indel_data<-read_csv("data/clinvar/benign_indel/benign_indel_transcript_exon_id_features",col_names=TRUE);
clinvar_pathogenic_indel_data<-read_csv("data/clinvar/pathogenic_indel/pathogenic_indel_transcript_exon_id_features",
                                        col_names=TRUE);

##remove the ones which didn't be predicted
clinvar_benign_indel_data<-filter(clinvar_benign_indel_data,!is.na(ss_1) );
clinvar_pathogenic_indel_data<-filter(clinvar_pathogenic_indel_data,!is.na(ss_1) );


##get the Exons in clinvar for randomforest
clinvar_exon_ids<-c(clinvar_benign_indel_data[,"exon_id"],clinvar_pathogenic_indel_data[,"exon_id"]);

##exclude the Exons in clinvar for randomforest, and only the features names.
all_data_no_exclude_clinvar<-all_data[!is.element(all_data[,"exon_id"],clinvar_exon_ids),feature_names];


model_randomForest_exlude_clinvar<-randomForest(formula=label~.,
                                   data=all_data_no_exclude_clinvar,
                                   ntree=100,mtry=12,proximity=TRUE,
                                   replace=FALSE,nodesize=19); 


predict_clinvar_indel_benign<-predict(model_randomForest_exlude_clinvar,
                                      clinvar_benign_indel_data,type="prob")[,1]; 
predict_clinvar_indel_pathogenic<-predict(model_randomForest_exlude_clinvar,
                                          clinvar_pathogenic_indel_data,type="prob")[,1]; 

#prepare for plot
clinvar_indel_data<-
  data.frame(value=c(predict_clinvar_indel_benign,predict_clinvar_indel_pathogenic),
                               label=c(rep("benign",length(predict_clinvar_indel_benign)), 
                                       rep("pathogenic",length(predict_clinvar_indel_pathogenic))) );

p<-ggplot(clinvar_indel_data)+
  geom_histogram(aes(x=value,y=..density..,fill=label),position="dodge" )+theme_classic()+
  xlab("FIS score")+
  scale_fill_manual(values=platte_black,name="")+
  theme(text=element_text(size=7))+
  ggtitle("Supplementary Figure 4\n Probability density for benign and pathogenic indel exons in Clinvar");


pdf("result/Supplementary Figure 4 (clinvar indel test).pdf",width=8,height=5);
print(p)
dev.off();

setEPS();
postscript("result/eps/Supplementary Figure 4 (clinvar indel test).eps",width=8,height=5);
print(p);
dev.off();


######################################log##############################################################################
cat(paste0("Size of clinvar benign indel is:",nrow(clinvar_benign_indel_data) ,"\n"),
    file="result/log.txt" ,append=TRUE) ;
cat(paste0("Size of clinvar pathogenic indel is:",nrow(clinvar_pathogenic_indel_data),"\n" ),
    file="result/log.txt" ,append=TRUE) ;


cat(paste0("wilcoxin test between clinvar being and pathogenic indels' FIS is: ",
           wilcox.test(predict_clinvar_indel_benign,predict_clinvar_indel_pathogenic,alternative = "less") ,"\n"),
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


