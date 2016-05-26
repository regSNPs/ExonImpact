library(ggplot2);
library(plyr)
library(dplyr);
library(readr)
library(reshape2);
library(magrittr);

setwd("/Users/mengli/Documents/splicingSNP_new/");

attr<-read_csv("data/GTEx/Brain_samplesAttributes_1.csv",col_names = F); 
attr_data<-as.data.frame(attr,stringAsFactors=F); 
donors<-substr(attr_data[,2],1,9)
donorNumber<-length(unique(donors));

flog.info( paste0("donors number: ",donorNumber ) ); 
flog.info( paste0("brain region number: ",length(unique(attr_data[,15])) ) );

result<-read.table("data/GTEx/region_miso_event_result.tsv",sep="\t",header=T,as.is=T); 
flog.info(paste0("number of events is: ",length(unique(result[,4])) )   ); 

gteX_fis_medianPSI<-ddply(result,.(event_name,fis),function(x){
    median_psi<-median(x[,"psi"]);
    return(median_psi);
}) %>% rename(median_psi=V1);

fis_group<-as.character(sapply(gteX_fis_medianPSI[,"fis"],function(x){
	if(x>0.91) return("FIS>0.91");
	if(x<=0.82) return("FIS<0.82");
	if(0.82<x&&x<=0.91) return("0.82<FIS<0.91");
} ) );

psi_group<-as.character(sapply(gteX_fis_medianPSI[,"median_psi"],function(x){
	if(x<=0.2) return("psi<0.2");
	if(0.2<x&&x<=0.4) return("0.2<psi<=0.4");
	if(0.4<x&&x<=0.6) return("0.4<psi<=0.6");
	if(0.6<x&&x<=0.8) return("0.6<psi<=0.8");
	if(0.8<=x) return("psi>0.8");
		
} ) );

gteX_fis_medianPSI<-mutate(gteX_fis_medianPSI,fis_group) %>% mutate(psi_group);

gteX_fis_medianPSI[,"psi_group"]<-factor(gteX_fis_medianPSI[,"psi_group"],
                             levels = c("psi<0.2","0.2<psi<=0.4","0.4<psi<=0.6","0.6<psi<=0.8","psi>0.8"),
                             ordered=TRUE ); 

gteX_fis_medianPSI[,"fis_group"]<-factor(gteX_fis_medianPSI[,"fis_group"],
                             levels=c("FIS<0.82","0.82<FIS<0.91","FIS>0.91" ),ordered=TRUE); 


fis_psi_percent<-ddply(gteX_fis_medianPSI,.(fis_group),function(x){
	a<-ddply(x,.(psi_group),summarise,length(event_name) )#/nrow(x);
	#print(a);
	a[,ncol(a)]<-a[,ncol(a)]/sum(a[,ncol(a)]);
	return(a);
}) %>% rename(percent=`length(event_name)`);


fis_psi_percent2<-ddply(fis_psi_percent,.(fis_group),transform,position=cumsum(percent)-0.5*percent );

fis_psi_percent2[,"position"]<-as.numeric(apply(fis_psi_percent2,1,function(x){
	if(!(x["psi_group"]=="psi>0.8") ){
		return(NA);
	}
	return(x["position"]);
}) );

#cbPalette1 <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7");
cbPalette2 <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7");

#fis_psi_percent_melt<-melt(fis_psi_percent)

p4<-ggplot(fis_psi_percent2,aes(x="",y=percent,fill=psi_group) )+#,fill=psi_group) )+#,fill=variable
	geom_bar(width=1,stat="identity")+theme_classic()+#position='dodge',
	#ggtitle(paste0("PSIs' wilcox test between fis<0.82 and 0.82<fis<0.91: 	P=",signif(testP,3) ) ) +
	ggtitle(expression(paste("Distribution of ",Psi," in different FIS group (Wilcoxin test p-value<",0.00394,")" )  ) )+
							   #scale_fill_discrete(name="",breaks=c("V1","V2","V3") 	,labels=c("Fis<0.82","0.82<Fis<0.91","Fis>0.91")  )+
	ylab("percent")+coord_polar(theta="y")+facet_wrap(~fis_group)+  
	scale_fill_manual(name=expression(paste(Psi, " group") ),
							   values=cbPalette2,breaks=c("psi<0.2","0.2<psi<=0.4","0.4<psi<=0.6","0.6<psi<=0.8","psi>0.8"),
							   labels=c(expression(paste(Psi,"<0.2")) ,expression(paste("0.2<",Psi,"<0.4")),  
							   expression(paste("0.4<",Psi,"<0.6")) ,expression(paste("0.6<",Psi,"<0.8")),
							   expression(paste("0.8<",Psi,"<1") ) )
					)+
	theme(text=element_text(size=7) )+geom_text(aes(label=sprintf("%1.2f%%",100*percent),y=position) );

	pdf("result/Figure-6 (GTEx test).pdf",width=8,height=4);
	print(p4);
	dev.off();

	setEPS();
	postscript("result/eps/Figure-6 (GTEx test).eps",width=8,height=4);
	print(p4);
	dev.off();



