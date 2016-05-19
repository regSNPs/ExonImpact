library(ggplot2);
library(dplyr);
library(plyr)
library(readr)
library(reshape2);

setwd("/Users/mengli/Documents/splicingSNP_new/");

attr<-read_csv("data/GTEx/Brain_samplesAttributes_1.csv",col_names = F); 
attr_data<-as.data.frame(attr,stringAsFactors=F); 
donors<-substr(attr_data[,2],1,9)
donorNumber<-length(unique(donors));
cat( paste0("donors number: ",donorNumber,"\n"),file="result/log.txt",append=TRUE ); 

cat( paste0("brain region number: ",length(unique(attr_data[,15])), "\n"),file="result/log.txt",append=TRUE );

result<-read.table("data/GTEx/region_miso_event_result.tsv",sep="\t",header=T,as.is=T); 
cat(paste0("number of events is: ",length(unique(result[,4])),"\n" ) ,file="result/log.txt",append=TRUE ); 

labelFis<-sapply(result[,"fis"],function(x){
  if(x<0.82){return("fis<0.82");};
  if(x>=0.82&&x<0.91){return("0.82<=fis<0.91")};
  return("fis>0.91");
});

labelPsi<-sapply(result[,"psi"],function(x){
  if(x<=0.2){return("psi<0.2");}
  if(0.2<x&&x<=0.4){return("0.2<psi<=0.4");}
  if(0.4<x&&x<=0.6){return("0.4<psi<=0.6");}
  if(0.6<x&&x<=0.8){return("0.6<psi<=0.8");}
  if(0.8<x&&x<=1){return("0.8<psi<=1")}
}); 
result<-cbind(result,labelFis,labelPsi); 

result[,"labelFis"]<-as.character(result[,"labelFis"]);
result[,"labelPsi"]<-as.character(result[,"labelPsi"]); 

fis_psi<-ddply(result,.(event_name,fis,labelFis),function(x){
  medianPsi<-median(x[,"psi"]);
  return(medianPsi);
  
} ); 

cat(paste0("The spearman correlation between fis and median psi is: ",
           cor(fis_psi[,2],fis_psi[,4],method="spearman"),"\n" ) ,file="result/log.txt",append=TRUE ); 


colnames(fis_psi)<-c("event_name","fis","labelFis","median_psi"); 
labelPsi<-sapply(fis_psi[,"median_psi"],function(x){
  if(x<=0.2){return("psi<0.2");}
  if(0.2<x&&x<=0.4){return("0.2<psi<=0.4");}
  if(0.4<x&&x<=0.6){return("0.4<psi<=0.6");}
  if(0.6<x&&x<=0.8){return("0.6<psi<=0.8");}
  if(0.8<x&&x<=1){return("0.8<psi<=1")}
  
});

fis_psi<-cbind(fis_psi,labelPsi); 
fis_psi[,"labelPsi"]<-factor(fis_psi[,"labelPsi"],
                             levels = c("psi<0.2","0.2<psi<=0.4","0.4<psi<=0.6","0.6<psi<=0.8","0.8<psi<=1"),
                             ordered=T ); 


fis_psi[,"labelFis"]<-factor(fis_psi[,"labelFis"],
                             levels=c("fis<0.82","0.82<=fis<0.91","fis>0.91" ),ordered=T); 
 

testP<-wilcox.test(fis_psi[fis_psi[,3]=="fis<0.82","median_psi"],
                   fis_psi[fis_psi[,3]=="fis>0.91","median_psi"] )$p.value; 

freByFis<-ddply(fis_psi,.(labelFis),nrow);
fis_psi[,"labelFis"]<-as.character(fis_psi[,"labelFis"]); 
resultPer<-ddply(fis_psi,.(labelPsi),function(x){ 
  fis085Count<-sum(x[,"labelFis"]=="fis<0.82"); 
  fis085091Count<-sum(x[,"labelFis"]=="0.82<=fis<0.91"); 
  fis091Count<-sum(x[,"labelFis"]=="fis>0.91"); 
  allCount<-nrow(x); 
  
  return(c(fis085Count/freByFis[1,"V1"],fis085091Count/freByFis[2,"V1"],
           fis091Count/freByFis[3,"V1"],allCount) ); 
}); 

for(i in 2:ncol(resultPer) ){
  cat(paste0(colnames(resultPer)[i],"'s percent of PSI>0.8 is: ",resultPer[5,i],"\n"),file="result/log.txt",append=TRUE);
  
}

colnames(resultPer)<-c("labelPsi","FIS<0.82","0.82<FIS<0.91","FIS>0.91","V4");
resultPermelt<-melt(resultPer,c("labelPsi","V4")); 

resultPermelt<-cbind(resultPermelt,resultPermelt[,"V4"]*resultPermelt[,"value"] ); 

colnames(resultPermelt)<-c("labelPsi","allCount","variable","value","count"); 


#resultPermelt[,"variable"]<-
cbPalette1 <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# The palette with black:
cbPalette2 <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

p4<-ggplot(resultPermelt,aes(x="",y=value,fill=labelPsi) )+#,fill=variable
  geom_bar(stat="identity" ,width=1)+theme_classic()+#position='dodge',
  #ggtitle(paste0("PSIs' wilcox test between fis<0.82 and 0.82<fis<0.91: P=",signif(testP,3) ) ) +
  ggtitle(expression(paste("Distribution of ",Psi," in different FIS group (Wilcoxin test p-value<",0.00394,")" )  ) )+
  #scale_fill_discrete(name="",breaks=c("V1","V2","V3") ,labels=c("Fis<0.82","0.82<Fis<0.91","Fis>0.91")  )+
  ylab("percent")+coord_polar(theta="y")+facet_wrap(~variable)+  
  scale_fill_manual(name=expression(paste(Psi, " group") ),
    values=cbPalette2,breaks=c("psi<0.2","0.2<psi<=0.4","0.4<psi<=0.6","0.6<psi<=0.8","0.8<psi<=1"),
                    labels=c(expression(paste(Psi,"<0.2")) ,expression(paste("0.2<",Psi,"<0.4")),  
                             expression(paste("0.4<",Psi,"<0.6")) ,expression(paste("0.6<",Psi,"<0.8")),
                             expression(paste("0.8<",Psi,"<1") ) 
                             
                             )
                    )+
  theme(text=element_text(size=7));
#geom_text(aes(label=count),position=position_dodge(width=0.9), );


pdf("result/Figure-6 (GTEx test).pdf",width=8,height=4);
print(p4);
dev.off();

setEPS();
postscript("result/eps/Figure-6 (GTEx test).eps",width=8,height=4);
print(p4);
dev.off();

