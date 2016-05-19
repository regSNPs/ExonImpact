library(randomForest);
library(readr);
library(dplyr);
library(R.devices);

setwd("/Users/mengli/Documents/splicingSNP_new/");
source("src/R/cv.r");
source("src/R/plot_roc.r");
source("src/R/bootstrap.r");

hgmd<-read_csv("data/hgmd_raw_data/hgmd_transcript_exon_id_features.csv",col_names=TRUE);
neutral<-read_csv("data/1000_genome_indel/1000_genome_transcript_exon_id_features.csv",col_names=TRUE);

hgmd<-hgmd[!is.na(hgmd[,"ss_1"]),];
neutral<-neutral[!is.na(neutral[,"ss_1"]),];


cat(paste0("Exons in HGMD is :",nrow(hgmd),"\n"),file="result/log.txt",append=TRUE);
cat(paste0("Exons in neutral is :",nrow(neutral),"\n"),file="result/log.txt",append=TRUE);

hgmd_sample<-hgmd[sample(1:nrow(hgmd),nrow(neutral) ),];

label<-c(rep("HGMD",nrow(hgmd_sample) ),rep("NEUTRAL",nrow(neutral))  );

all_data<-cbind(rbind(hgmd_sample,neutral),label);
all_data_no_na<-all_data[!is.na(all_data[,"proteinLength"]),];

feature_names<-c("label","phylop","ss_1","ss_2","ss_3","ss_4","ss_5",
                      "ss_6","ss_7","ss_8","ss_9","ss_10","ss_11","ss_12",
                      "asa_1","asa_2","asa_3",
                      "disorder_1","disorder_2","disorder_3","disorder_4",
                      "disorder_5","disorder_6","disorder_7","disorder_8",
                      "disorder_9","disorder_10","disorder_11","disorder_12",
                      "pfam1","pfam2","ptm","proteinLength");

all_data_filter<-all_data_no_na[,feature_names];
all_data_filter[is.na(all_data_filter[,"disorder_3"]),"disorder_3"]<-0;
all_data_filter[!is.finite(all_data_filter[,"disorder_3"]),"disorder_3"]<-0;

set.seed(1010);
all_data_filter<-sample_n(all_data_filter,nrow(all_data_filter));

modelrandomforestAll<-randomForest(formula=label~.,
                                   data=all_data_filter,
                                   ntree=100,mtry=12,proximity=TRUE,
                                   replace=FALSE,nodesize=19); 

save(modelrandomforestAll,file="result/model");

importantFeatures<-importance(modelrandomforestAll); 


predictResultCV<-crossValidateRandomForest(all_data_filter,10);
predictResultBoostrap<-bootstrapRandomForest(all_data_filter,100);


#par(mfrow=c(1,2));
roc_data_boost<-plot_roc(predictResultBoostrap,"100-bootstrap validation");
roc_data_cv<-plot_roc(predictResultCV,"10-cross validation");

auc_boost<-mean(sample(predictResultBoostrap[predictResultBoostrap$label=="HGMD","prob"],1000000,replace=TRUE) >
                 sample(predictResultBoostrap[predictResultBoostrap$label=="NEUTRAL","prob"],1000000,replace=TRUE) );

auc_cv<-mean(sample(predictResultCV[predictResultCV$label=="HGMD","prob"],1000000,replace=TRUE) >
                  sample(predictResultCV[predictResultCV$label=="NEUTRAL","prob"],1000000,replace=TRUE) );


roc_data<-rbind(roc_data_cv,roc_data_boost);

roc_data<-cbind(roc_data,
                c(rep(paste0("100 times boostrap AUC= ",signif(auc_boost,3) ),nrow(roc_data_boost)),
                  rep(paste0("10 cross-validation AUC=",signif(auc_cv,3) ),nrow(roc_data_cv))  
                  )  );
colnames(roc_data)<-c("fpr","tpr","method");

p<-ggplot(roc_data,aes(x=fpr,ymin=0,ymax=tpr))+geom_ribbon(fill="gray66")+#geom_area(fill="green")+
  xlab("False Positive Rate")+ylab("True Positive Rate")+theme_classic()+
  ggtitle("Supplement Figure 3 100 times boostrap and 10 cross-validation")+
  facet_wrap(~method)+  theme(text=element_text(size=7));

pdf("result/Supplement Figure 3 (cv&bootstrap).pdf",width=8,height=5);
print(p);

dev.off();


setEPS();
postscript("result/eps/Supplement Figure 3 (cv&bootstrap).eps", width=8,height=5 );
print(p);
dev.off();


