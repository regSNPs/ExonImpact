alldatasetNAlogic<-all_data_filter
#alldatasetNAlogic<-alldatasetNA[!is.na(alldatasetNA[,"ptm"]),];
alldatasetNAlogic[,"label"]<-factor(alldatasetNAlogic[,"label"],levels=c("NEUTRAL","HGMD") );

ptm_asa_logic<-glm(label~asa_1+ptm,alldatasetNAlogic,family="binomial");

write.table(summary(ptm_asa_logic)$coefficients,file="result/log.txt",sep="\t",append=TRUE);

