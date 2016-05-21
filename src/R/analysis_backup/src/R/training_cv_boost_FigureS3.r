library(randomForest);
library(readr);
library(plyr)
library(dplyr);
library(ggplot2)
library(R.devices);

setwd("/Users/mengli/Documents/splicingSNP_new/");
source("src/R/get_roc_data.r");
source("src/R/cv.r");
source("src/R/bootstrap.r");

set.seed(1010);

hgmd<-read_csv("data/hgmd_raw_data/hgmd_transcript_exon_id_features.csv",col_names=TRUE);
neutral<-read_csv("data/1000_genome_indel/1000_genome_transcript_exon_id_features.csv",col_names=TRUE);

##remove the ones which can't be predicted!!
hgmd<-filter(hgmd,!is.na(ss_1) );
neutral<-filter(neutral,!is.na(ss_1) );

cat(paste0("Exons in HGMD is :",nrow(hgmd),"\n"),file="result/log.txt",append=TRUE);
cat(paste0("Exons in neutral is :",nrow(neutral),"\n"),file="result/log.txt",append=TRUE);

#sample rows from hgmd, since hgmd contain more exons than neutral. 
hgmd_sample<-sample_n(hgmd,nrow(neutral) );

#add label
label<-factor(c(rep("HGMD",nrow(hgmd_sample) ),rep("NEUTRAL",nrow(neutral))  ) );
all_data<-cbind(rbind(hgmd_sample,neutral),label);

feature_names<-c("label","phylop","ss_1","ss_2","ss_3","ss_4","ss_5",
                      "ss_6","ss_7","ss_8","ss_9","ss_10","ss_11","ss_12",
                      "asa_1","asa_2","asa_3",
                      "disorder_1","disorder_2","disorder_3","disorder_4",
                      "disorder_5","disorder_6","disorder_7","disorder_8",
                      "disorder_9","disorder_10","disorder_11","disorder_12",
                      "pfam1","pfam2","ptm","proteinLength");

##add the label 'HGMD' or 'NEUTRAL' to the dataset.
all_data_filter<-as.data.frame( sample_n(all_data,nrow(all_data))[,feature_names]);

modelrandomforestAll<-randomForest(formula=label~.,
                                   data=all_data_filter,
                                   ntree=100,mtry=12,proximity=TRUE,
                                   replace=FALSE,nodesize=19); 

save(modelrandomforestAll,file="result/model");

roc_data_cv<-crossValidateRandomForest(all_data_filter,10) %>% 
  get_roc_data("10-cross validation","HGMD","NEUTRAL");

roc_data_boost<-bootstrapRandomForest(all_data_filter,100) %>%
  get_roc_data("100-bootstrap validation","HGMD","NEUTRAL");

auc_boost<-roc_data_boost[1,"auc"]; auc_cv<-roc_data_cv[1,"auc"];

##prepare for ggplot
roc_data<-rbind(roc_data_cv,roc_data_boost);
roc_data_select<-roc_data[,c("fpr","tpr")];

method_name<-c(rep(paste0("a   100 times boostrap AUC= ",signif(auc_boost,3) ),nrow(roc_data_boost)),
  rep(paste0("b   10 cross-validation AUC=",signif(auc_cv,3) ),nrow(roc_data_cv))  );
roc_data_select<-cbind(roc_data_select,method_name);

##plot
p<-ggplot(roc_data_select,aes(x=fpr,ymin=0,ymax=tpr))+geom_ribbon(fill="gray66")+#geom_area(fill="green")+
  xlab("False Positive Rate")+ylab("True Positive Rate")+theme_classic()+
  ggtitle("Supplement Figure 3 100 times boostrap and 10 cross-validation")+
  facet_wrap(~method_name)+  theme(text=element_text(size=7));

#output
pdf("result/Supplement Figure 3 (cv&bootstrap).pdf",width=8,height=5);
print(p);
dev.off();

setEPS();
postscript("result/eps/Supplement Figure 3 (cv&bootstrap).eps", width=8,height=5 );
print(p);
dev.off();

