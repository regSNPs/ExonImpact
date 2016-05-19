library(stringr);
library(pROC);

plotEachfeature<-function(){
  
  
  text<-str_c("number of neutral exons:",nrow(all_data_filter[all_data_filter[,1]=="NEUTRAL",]),
              "\nnumber of HGMD exons:",nrow(all_data_filter[all_data_filter[,1]=="HGMD",])   );
  
  for(i in 2:(ncol(all_data_filter)) ){
    
    featureName=colnames(all_data_filter)[i];
    currentFeature<-data.frame(all_data_filter[,1],all_data_filter[,i]);
    colnames(currentFeature)<-c("label","feature" );
    
    #plot(x = 1:10, y = 10:1)
    aroc<-1
    
    aroc<-roc(currentFeature[,1],currentFeature[,2],direction="auto");
d_value<-ks.test(currentFeature[currentFeature[,1]=="HGMD",2],currentFeature[currentFeature[,1]=="NEUTRAL",2] )$statistic;
p_value<-ks.test(currentFeature[currentFeature[,1]=="HGMD",2],currentFeature[currentFeature[,1]=="NEUTRAL",2] )$p.value;
    
    cbbPalette <- c("gray66", "gray21", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7");
    
    a<-ggplot(currentFeature,mapping=aes(x=feature))+
      #geom_density(mapping=aes(color=label),adjust=0.4)+
      geom_histogram(mapping=aes(fill=label,y=..density..),position="dodge")+
      xlab(featureName)+theme(legend.title=element_blank())+
      ggtitle(paste0("AUC : ",format(aroc$auc,digits=3),"\nKS-test D-value: ",
                     format(d_value,digits=3),"\nKS-test P-value: ",format(p_value,digits=3) ) )+
      theme_classic()+scale_fill_manual(values=cbbPalette)+xlab("feature");
      
    print(a);
  }
  
}

pdf("result/Supplemnet Figure-2 (evaluate each feature).pdf",width=5,height=3);
plotEachfeature();
dev.off();


setEPS();
postscript("result/eps/Supplement Figure-2 (evaluate each feature).eps",width=5,height=3,onefile = TRUE);
plotEachfeature();
dev.off();

