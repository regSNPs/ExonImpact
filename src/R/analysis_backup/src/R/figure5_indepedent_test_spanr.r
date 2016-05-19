library(ggplot2);
library(reshape2);
library(gridBase);
library(grid);

setwd("/Users/mengli/Documents/splicingSNP_new/");
source("src/R/multiplot.r");

nLine<-as.integer(nrow(all_data_filter)/3*2);

all_data_train<-all_data_filter[1:nLine,];
all_data_test<-all_data_filter[(nLine+1):nrow(all_data_filter),];

#all_data_trainSelect<-all_data_train[,c("label",selectFeatures )];

#for refseq
modelrandomforest<-randomForest(formula=label~.,
                                data=all_data_train,
                                ntree=100,proximity=TRUE,
                                replace=FALSE,nodesize=19,mtry=12);

predictValues<-predict(modelrandomforest,all_data_test,type="prob")[,1];

tprFun<-function(x){
  t<-sum(predictValues[all_data_test$label=="HGMD"]>x)/sum(all_data_test$label=="HGMD");
  return(t);
}

fprFun<-function(x){
  t<-sum(predictValues[all_data_test$label=="NEUTRAL"]>x)/sum(all_data_test$label=="NEUTRAL");
  return(t);
}

f1Fun<-function(x){
  tp<-sum(predictValues[all_data_test$label=="HGMD"]>x );   #tp
  fp<-sum(predictValues[all_data_test$label=="NEUTRAL"]>x); #fp
  fn<-sum(predictValues[all_data_test$label=="HGMD"]<x);    #fn
  f1<-(2*tp)/(2*tp+fp+fn);
  
  return(f1);
}

fdrFun<-function(x){
  t<-sum(predictValues[all_data_test$label=="NEUTRAL"]>x)/sum(predictValues>x); #fdr
}

mccFun<-function(x){
  tp<-sum(predictValues[all_data_test$label=="HGMD"]>x );      #tp
  tn<-sum(predictValues[all_data_test$label=="NEUTRAL"]<x );   #tp
  fp<-sum(predictValues[all_data_test$label=="NEUTRAL"]>x);    #fp
  fn<-sum(predictValues[all_data_test$label=="HGMD"]<x);       #fn
  #print( paste0(tp," ",tn," ",fp," ",fn,"\n") );
  
  mcc<-( (tp*tn)-(fp*fn) )/( sqrt(tp+fp)*sqrt(tp+fn)*sqrt(tn+fp)*sqrt(tn+fn) ); 
  return(mcc);
}

thresholds<-seq(-0,1.1,0.001);

tpr<-sapply(thresholds,tprFun);
fpr<-sapply(thresholds,fprFun);
f1<- sapply(thresholds,f1Fun);
fdr<-sapply(thresholds,fdrFun);
mcc<-sapply(thresholds,mccFun);

auc_value<-mean(sample(predictValues[all_data_test$label=="HGMD"],1000000,replace=T) >
                 sample(predictValues[all_data_test$label=="NEUTRAL"],1000000,replace=T));

#p1<-ggplot()+geom_line(aes(x=fpr,y=tpr))+
p1<-ggplot( )+geom_ribbon(aes(x=fpr,ymin=0,ymax=tpr),fill="gray66")+ #geom_area(fill="green")+
  
  #ggtitle(paste0("A  (AUC=",auc_value,")"))+
  xlab("Fasle Positive Rate")+ylab("True Positive Rate")+theme_classic()+theme(text=element_text(size=7))+
  #ylim(0,1.2)+
  geom_text(aes(x=0.1,y=1.2), colour = "black", fontface = "bold",label="a  ",size = 4)+
  #geom_text(aes(x=0.5,y=1.2), colour = "black",size = 4,label=paste0("Independent test (AUC=",signif(auc_value,3),")" ) );
ggtitle(paste0("Independent test (AUC=",signif(auc_value,3),")" ) );
#,xlab="False Positive Rate",ylab="True Positive Rate",type="l",xlim=c(0,1),ylim=c(0,1) );

#aucValue<-troc$auc;

cutoffs <- data.frame(cut=thresholds, tpr=tpr, fpr=fpr,f1=f1,mcc=mcc);
write.csv(cutoffs,file="result/independent_test_cutoff.csv",quote=FALSE,row.names=FALSE);

cutoffs2<-melt(cutoffs,"cut");
p2<-ggplot(cutoffs2) + geom_smooth(aes(x=cut,y=value,color=variable) )+
  geom_segment(aes(x = 0, y = 0.1, xend = 1, yend = 0.1) )+
  geom_segment(aes(x = 0.84, y = 0, xend = 0.84, yend = 1) )+
  geom_segment(aes(x = 0, y = 0.4765, xend = 1, yend = 0.4765) )+
  geom_text(aes(x=0.05 ,y=0.14, label="y=0.1") )+
  scale_colour_discrete(name="Measures",
                        breaks=c("tpr", "fpr","f1","mcc"),
                        labels=c("True positive rate", "False positive rate","F1 Score","MCC"))+
  #xlim(0,1)+ylim(0,1)+
  xlab("cutoff")+theme_classic()+xlim(0,1)+ylim(0,1.2)+theme(text=element_text(size=7))+
  geom_text(aes(x=0.05,y=1.2), colour = "black", fontface = "bold",label="c  ",size = 4)+
  #geom_text(aes(x=0.5,y=1.2), colour = "black",size = 4,label="TPR, FPR, F1 score and MCC change with cutoff" );
  #theme(legend.title=element_text("measures") );
  ggtitle("TPR, FPR, F1 score and MCC change with cutoff");

print(p2);

psi_percent<-c(0.054,0.083,0.167);
names(psi_percent)<-c("|PSI|>20%","10%<|PSI|<20%","|PSI|<10%");

psiData<-data.frame(percent=psi_percent,names=names(psi_percent) );
psiData[,"names"]<-factor(psiData[,"names"],levels=c("|PSI|>20%","10%<|PSI|<20%","|PSI|<10%"));

p3<-ggplot(psiData)+geom_bar(aes(x=names,y=percent),stat="identity") +theme_classic()+
  ylim(0,0.20)+theme(text=element_text(size=7))+
  geom_text(aes(x=0.6,y=0.197), colour = "black", fontface = "bold",label="b  ",size = 4)+
  scale_x_discrete(breaks=c("|PSI|>20%", "10%<|PSI|<20%", "|PSI|<10%"),
                   labels=c(expression(paste("|",Delta,Psi,"|>20%") ), 
                            expression(paste("10%<|",Delta,Psi,"|<20%") ),
                            expression(paste("|",Delta,Psi,"|<10%") )))+
  #geom_text(aes(x=2,y=0.19), colour = "black",size = 4, label="Percentile of high disease score (>0.91)\n in different PSI group" );
    ggtitle(expression(paste("Percentile of high disease score (>0.91) in different |",
                             Delta,Psi, "| group" ) ) );


pdf("result/Figure-5 (independent test&spanr test).pdf",width=8,height=6.5);
plot.new();
gl <- grid.layout(nrow=2, ncol=2, heights=c(1,1), widths=c(1,1) );
pushViewport(viewport(layout=gl)  );

vp1 <- viewport(layout.pos.row=1, layout.pos.col=1);
vp2 <- viewport(layout.pos.row=2, layout.pos.col=1:2);
vp3 <- viewport(layout.pos.row=1, layout.pos.col=2);

pushViewport(vp1);
print(p1,newpage = FALSE);
popViewport();

pushViewport(vp2);
print(p2,newpage = FALSE);
popViewport();

pushViewport(vp3);
print(p3,newpage = FALSE);
popViewport();

dev.off();



setEPS();
eps("result/eps/Figure-5 (independent test&spanr test).eps",width=8,height=6.5);

plot.new();
gl <- grid.layout(nrow=2, ncol=2, heights=c(1,1), widths=c(1,1) );
pushViewport(viewport(layout=gl)  );

vp1 <- viewport(layout.pos.row=1, layout.pos.col=1);
vp2 <- viewport(layout.pos.row=2, layout.pos.col=1:2);
vp3 <- viewport(layout.pos.row=1, layout.pos.col=2);

pushViewport(vp1);
print(p1,newpage = FALSE);
popViewport();

pushViewport(vp2);
print(p2,newpage = FALSE);
popViewport();

pushViewport(vp3);
print(p3,newpage = FALSE);
popViewport();

dev.off();


