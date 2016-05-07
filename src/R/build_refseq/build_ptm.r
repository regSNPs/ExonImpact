library(dplyr);
library(plyr);
library(readr);

setwd("/Users/mengli/Documents/projects/new_tool");

idMapping<-as.data.frame(read_tsv("HUMAN_9606_idmapping.dat",col_names=FALSE),stringsAsFactors=FALSE);
colnames(idMapping)<-c("UniProtKB.ID","source","mapping");

#only keep the ensembl transcript id
#idMapping<-idMapping[idMapping[,"source"]=="Ensembl_TRS",];

#keep the refseq transcript id
idMapping<-idMapping[idMapping[,"source"]=="RefSeq_NT",];

dbPTM<-as.data.frame(read_tsv("dbPTM3.txt",col_names=FALSE),stringsAsFactors=FALSE);
colnames(dbPTM)<-c("organism","UniProtKB.ID","position","word","pubmedID","source_db","shortCode","modification");

ptm<-inner_join(idMapping,dbPTM,by=c("UniProtKB.ID"="UniProtKB.ID") );
ptms<-unique(ptm[,"modification"]);
cat(ptms,file="ptm.list",sep="\n");

resultTable<-ptm[,c("mapping","UniProtKB.ID","position","modification")];
resultTable[,"mapping"]<-sapply(strsplit(resultTable[,"mapping"],"\\."),"[",1 ); 

write.table(resultTable,file="ptm_for_sqllite.tsv",quote=FALSE,col.names=FALSE,row.names=FALSE,sep="\t");
