library(randomForest)
library(plyr)
#source("Global.r")
#source("multiPlot.r");

despv<-commandArgs(TRUE)[[1]];
#despv<-"/Users/mengli/Documents/splicingSNP_new/data/build_db/miso_test/se_events_features.csv";

#"forest"
load("model");

despData<-read.table(file=despv, sep=",",header=TRUE,fill=TRUE,row.names=NULL);
#colnames(despData)<-colnames(despData)[-1]

despData<-despData[,1:38]

despData_noNa<-despData[!is.na(despData[,ncol(despData)]),,drop=FALSE];

despData_noNa_filter<-despData_noNa[order(despData_noNa[,"is_match"],decreasing=TRUE),,drop=FALSE];

despData_noNa_filter_one_trans<-despData_noNa_filter[!duplicated(despData_noNa_filter[]),];


disease_probability<-predict(modelrandomforestAll,despData_noNa_filter_one_trans,type="prob")[,1];


resultTable<-cbind(disease_probability,despData_noNa_filter_one_trans);


allFeatureNames<-c("transcript_id","raw_input","disease_probability","phylop",
                     "ss_1","ss_2","ss_3","ss_4","ss_5",
                     "ss_6","ss_7","ss_8","ss_9","ss_10","ss_11","ss_12",
                     "asa_1","asa_2","asa_3",
                     "disorder_1","disorder_2","disorder_3","disorder_4",
                     "disorder_5","disorder_6","disorder_7","disorder_8",
                     "disorder_9","disorder_10","disorder_11","disorder_12",
                     "pfam1","pfam2","ptm","proteinLength");
                     
resultTable<-resultTable[,allFeatureNames]              


write.table(resultTable,file=paste0(despv,".predict.tsv"),
            sep="\t",row.names=FALSE,col.names=FALSE, 
            quote=FALSE ,append=TRUE);

jsonFileName<-paste0(despv,".predict.json.tsv");
cat("{\n\"data\":[\n",file=jsonFileName ,append=FALSE)
for(i in 1:nrow(resultTable)){
  
  cat("{\n",file=jsonFileName ,append=TRUE)
  #cat(paste0("\"",rownames(result)[i],"\"\n"),file=jsonFileName,append=TRUE)
  cat(paste0("\"",colnames(resultTable)[1],"\":\"",resultTable[i,1],"\"\n"),file=jsonFileName,append=TRUE); 
  
  for(j in 2:ncol(resultTable)){
    cat(paste0(",\n\"",colnames(resultTable)[j],"\":\"",resultTable[i,j],"\""),file=jsonFileName ,append=TRUE); 
  }
  
  if(i!=nrow(resultTable)){
    cat("},\n",file=jsonFileName ,append=TRUE)
  }else{
    cat("}\n",file=jsonFileName ,append=TRUE)
  }
  
}
cat("]\n}",file=jsonFileName ,append=TRUE);


