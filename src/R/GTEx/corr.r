library(plyr)
library(readr);

#attrFilePath<-"/N/dc2/projects/ngs/GTEX_dbgap/phenotype_genotype/44407/PhenoGenotypeFiles/RootStudyConsentSet_phs000424.GTEx.v4.p1.c1.GRU/PhenotypeFiles/Brain_samplesAttributes_1.csv";
attrFilePath<-"Brain_samplesAttributes_1.csv";

attrData<-read.table(attrFilePath,sep=",",header=F,as.is=T); 
regionName<-"Brain - Substantia nigra";

sampleNames<-attrData[attrData[,15]==regionName,2];

misoAnnoPath<-"SE_ID.txt";
misoAnnoData<-read.table(misoAnnoPath,sep="\t",header=F,as.is=T);

eventNames<-unique(misoAnnoData[,1]);

misoDisease<-"sedesp.predict.tsv";
misoDiseaseScore<-read.table(misoDisease,sep="\t",header=T,as.is=T); 
#eventNames<-misoDiseaseScore[,"input"];

misoMergeRaw<-read.table("miso_merge.tsv",header=F,as.is=T,sep="\t");

misoMergeEditNames<-sapply(strsplit(misoMergeRaw[,1],"\\."),"[",2 );
misoMergeEdit<-misoMergeRaw;misoMergeEdit[,1]<-misoMergeEditNames;

misoMerge<-misoMergeEdit[is.element(misoMergeEdit[,1],sampleNames),];
misoMerge<-misoMerge[is.element(misoMerge[,2],eventNames),]

misoEventMap<-list();
for(i in 1:nrow(misoMerge)){
  misoEventMap[[misoMerge[i,2] ]]<-c(misoEventMap[[misoMerge[i,2] ]],i);
  if(i%%10000==0){
    print(paste0(i) ) 
  }
}

result<-data.frame(variability=c(),fxi=c(),sampleName=c(),eventName=c(),psi=c() );
dci<-c();misoOneEvent<-c();

dci_filter_count<-0;
sample_count<-0;

for(i in 1:length(eventNames)){
  
  misoOneEvent<-misoMerge[misoEventMap[[eventNames[i]]],] 
  if(nrow(misoOneEvent)<10){
    sample_count=sample_count+1;
   next;
  }
  #print(i) 
  
  dci<-misoOneEvent[,"V5"]-misoOneEvent[,"V4"];
  if( sum(dci<0.1)<10 ){
     dci_filter_count=dci_filter_count+1;
    next;
  }
  misoOneEvent<-misoOneEvent[dci<0.1,1:3,drop=F];

  cat(file="eventCount")
  cat(paste0(nrow(misoOneEvent),"\n"),file="eventCount",append=TRUE);
  
  vari<-sd(misoOneEvent[,3]); 
  fis<-misoDiseaseScore[misoDiseaseScore[,"input"]==eventNames[i],"disease_probability"];
  
  numberOfEvents<-nrow(misoOneEvent);
#  misoOneEventResult<-cbind(rep(vari,numberOfEvents),rep(fis,numberOfEvents),misoOneEvent);
  
 # result<-rbind(result,misoOneEventResult);
  
  #result<-rbind(result,c(variability,fxi) );
}
cat(paste0("filtered events by sample_count<10:",sample_count,"\n") );
cat(paste0("filtered events by dci:",dci_filter_count),"\n");

colnames(result)<-c("sd","fis","sample_name","event_name","psi");

write.table(result,file="region_miso_event_result.tsv",sep="\t",quote=F,row.names=F);

colnames(misoMergeEdit)<-c("sample_name","event_name","psi","lci","fci");
colnames(attrData)[2]<-"sample_name";
misoMergeEditRegion<-join(misoMergeEdit,attrData,by="sample_name",type="inner" );

eventAnnova<-ddply(misoMergeEditRegion,.(event_name),function(x){
  
  pvalue<-NA;
  tryCatch(pvalue<-oneway.test(psi ~V15 ,x)$p.value,error=function(e){return(NA);} );
  sample_count<-paste0(daply(x,.(V15),function(y){return(nrow(y));} ),collapse=",")
  
  return(c(pvalue,sample_count));
});

write.table(eventAnnova,file="event_anova_p-value.tsv",sep="\t",row.names=F);

write.table(misoMergeEditRegion[,c("sample_name","event_name","psi","V15")],file="misoMergeRegion.csv",sep=",",quote=T,row.names=T);


