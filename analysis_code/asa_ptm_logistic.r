alldatasetNAlogic<-all_data_filter
#alldatasetNAlogic<-alldatasetNA[!is.na(alldatasetNA[,"ptm"]),];
alldatasetNAlogic[,"label"]<-factor(alldatasetNAlogic[,"label"],levels=c("NEUTRAL","HGMD") );

ptm_asa_logic<-glm(label~asa_1+ptm,alldatasetNAlogic,family="binomial");

flog.info(summary(ptm_asa_logic)$coefficients );

