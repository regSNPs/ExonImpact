library(stringr);
library(reshape2);
library(ggplot2);
library(R.devices);

setwd("/Users/mengli/Documents/splicingSNP_new/");
source("src/R/platte.r");
source("src/R/feature_alt.r");

d_values<-c();
p_values<-c();
panel_labels<-c("a","b","c","d","e",
                "f","g","h","i","j",
                "k","l","m","n","o",
                "p","q","r","s","t",
                "u","v","w","x","y",
                "z","aa","ab","ac","ad","ae","af");

#calculate the KS-test p-value and d-value
for(i in 2:(ncol(all_data_filter)) ){
  currentFeature<-data.frame(all_data_filter[,1],all_data_filter[,i]);
  #d_value<-ks.test(currentFeature[currentFeature[,1]=="HGMD",2],
  #currentFeature[currentFeature[,1]=="NEUTRAL",2] )$statistic;
  
  cur_fea_name<-names(currentFeature)[2];
  p_value<-wilcox.test(currentFeature[currentFeature[,1]=="HGMD",2],
                       currentFeature[currentFeature[,1]=="NEUTRAL",2],
                       alternative=feature_alternative[[cur_fea_name]])$p.value;
  #d_values<-c(d_values,d_value);
  p_values<-c(p_values,p_value);
}

#summarisie the statistic data
all_data_stat<-data.frame(name=colnames(all_data_filter)[-1],
                          #d_values=d_values,
                          p_values=p_values,
                          label=panel_labels[1:length(p_values)] );

#calcuate the blank space
blank_pre<-apply(all_data_stat,1,function(x){
  name<-x["name"];
  name_len<-nchar(as.character(name));
  
  #d_values<-as.numeric(x["d_values"] );
  p_values<-as.numeric(x["p_values"] );
  #d_len<-nchar(signif(d_values,3) );
  d_len<-0;
  p_len<-nchar(signif(p_values,3) );
  
  len<-30-(name_len+d_len+p_len);
  re<-paste(rep(" ",len ),collapse="" );
  return(re);
});

#change the feature name to add p-value and d-value.
stat_names<-str_c(all_data_stat$label,blank_pre,all_data_stat$name,
                  #" (d-value=",signif(all_data_stat$d_values,3),
                  "  (p-value=",signif(all_data_stat$p_values,3),")" );

all_data_filter_figure2<-all_data_filter;
colnames(all_data_filter_figure2)<-c("label",stat_names);


all_data_filter_melt<-melt(all_data_filter_figure2,.(label) ); 

a<-ggplot(all_data_filter_melt,mapping=aes(x=value))+
  geom_histogram(mapping=aes(fill=label,y=..density..),position="dodge")+
  xlab("feature")+theme(legend.title=element_blank())+
  theme_minimal()+theme(axis.ticks = element_blank(), axis.text.y = element_blank())+
  
  #ggtitle(paste0("AUC : ",format(aroc$auc,digits=3),"\nKS-test D-value: ",
  #               format(d_value,digits=3),"\nKS-test P-value: ",format(p_value,digits=3) ) )+
  scale_fill_manual(values=platte_black)+facet_wrap(~variable,ncol = 3,scales="free")+
  theme(legend.position="top" ,legend.title=element_blank(),text=element_text(size=7) )+
  ggtitle("Supplementary Figure 2 Probability density of each feature")+xlab("feature")+
  #geom_label(aes(x=min(value),y=1,label="a") ); 


pdf("result/Supplementary Figure 2 (Distribution for each feature).pdf",width=8,height=9)
print(a);
dev.off();


setEPS();
postscript("result/eps/Supplementary Figure 2 (Distribution for each feature).eps",width=8,height=9);
print(a);
dev.off();
