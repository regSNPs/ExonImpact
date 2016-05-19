library(randomForest)
library(dplyr)
#source("Global.r")
#source("multiPlot.r");

despv<-commandArgs(TRUE)[[1]];

#plot(roc(allData$labelAll,allData$pfam));
loadData<-function(desp){
  
  despasass<-read.table(paste0(desp,".asa.ss.max_prob.data"),sep="\t",header=FALSE,as.is=TRUE);
  colnames(despasass)<-c("snpId","ss_1","ss_2","ss_3","ss_4","ss_5",
                         "ss_6","ss_7","ss_8","ss_9","ss_10","ss_11","ss_12",
                         "asa_1","asa_2","asa_3","exonId","ave_asa");
  
  despdisorder<-read.table(paste0(desp,".snp.ref.mut.seq.disorder-matrix"),sep="\t",header=FALSE,as.is=TRUE);
  colnames(despdisorder)<-c("snpId","region","disorder_1","disorder_2","disorder_3","disorder_4",
                            "disorder_5","disorder_6","disorder_7","disorder_8",
                            "disorder_9","disorder_10","disorder_11","disorder_12","exonId");
  
  desppfam<-read.table(paste0(desp,".snp.ref.mut.seq.pfam-matrix"),sep="\t",header=TRUE,as.is=TRUE);
  desppfam<-data.frame(id=desppfam[,"id"],pfam1=desppfam[,"overlap"],
                       pfam2=desppfam[,"coverage"],
                       exonId=desppfam[,"exonId"],stringsAsFactors = FALSE ); 
  
  despptm<-read.table(paste0(desp,".snp.ref.mut.seq.ptm-matrix.dbPTM"),sep="\t",header=TRUE,as.is=TRUE,quote=NULL);
  despptm<-data.frame(id=despptm[,"id"],ptm=rowSums(despptm[,3:(ncol(despptm)-1) ] ),
                      exonId=despptm[,"exonId"] ,stringsAsFactors = FALSE); 
  
  despPhylop<-read.table(paste0(desp,".snp.ref.mut.seq.mutBed.phylop"),sep="\t",header=FALSE,as.is=TRUE);
  colnames(despPhylop)<-c("snpId","phylop","r1","r2","r3","r4","exonId");
  
  despData<-inner_join(despasass,despdisorder,by=c("snpId"="snpId","exonId"="exonId") );
  despData<-inner_join(despData,desppfam,by=c("snpId"="id","exonId"="exonId") );
  despData<-inner_join(despData,despptm,by=c("snpId"="id","exonId"="exonId") );
  despData<-inner_join(despData,despPhylop,by=c("snpId"="snpId","exonId"="exonId") );
  
  despData<-despData[!duplicated(despData[,"snpId"]),];
  rownames(despData)<-paste0(despData[,"snpId"],"$",despData[,"exonId"],"$",despData[,"region"],"$","desp");
  
  allFeatureNames<-c("snpId","phylop",
                     "ss_1","ss_2","ss_3","ss_4","ss_5",
                     "ss_6","ss_7","ss_8","ss_9","ss_10","ss_11","ss_12",
                     "asa_1","asa_2","asa_3",
                     "disorder_1","disorder_2","disorder_3","disorder_4",
                     "disorder_5","disorder_6","disorder_7","disorder_8",
                     "disorder_9","disorder_10","disorder_11","disorder_12",
                     "pfam1","pfam2","ptm");
  
  despData<-despData[,allFeatureNames];
  return(despData);
}

#"forest"
load("code/model");
despData<-loadData(despv);

disease_probability<-predict(modelrandomforestAll,despData,type="prob")[,1];

result<-cbind(disease_probability,despData);
inputData<-read.table(paste0(despv,".map"),sep="\t",header=FALSE,as.is=TRUE );
colnames(inputData)<-c("id","input");

resultTable<-inner_join(inputData,result,by=c("id"="snpId"))
cat(paste(c(colnames(resultTable),"\n"),collapse="\t"),file=paste0(despv,".predict.tsv"),append=TRUE);

write.table(resultTable,file=paste0(despv,".predict.tsv"),
            sep="\t",row.names=FALSE,col.names=FALSE, 
            quote=FALSE ,append=TRUE);

jsonFileName<-paste0(despv,".predict.json.tsv");
cat("{\n\"data\":[\n",file=jsonFileName ,append=FALSE)
for(i in 1:nrow(resultTable)){
  
  cat("[\n",file=jsonFileName ,append=TRUE)
  #cat(paste0("\"",rownames(result)[i],"\"\n"),file=jsonFileName,append=TRUE)
  cat(paste0("\"",resultTable[i,1],"\"\n"),file=jsonFileName,append=TRUE); 
  
  for(j in 2:ncol(resultTable)){
    cat(paste0(",\n\"",resultTable[i,j],"\""),file=jsonFileName ,append=TRUE); 
  }
  if(i!=nrow(resultTable)){
    cat("],\n",file=jsonFileName ,append=TRUE)
  }else{
    cat("]\n",file=jsonFileName ,append=TRUE)
  }
  
}
cat("]\n}",file=jsonFileName ,append=TRUE)
