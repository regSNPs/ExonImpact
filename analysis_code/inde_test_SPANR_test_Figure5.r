library(ggplot2);
library(reshape2);
library(gridBase);
library(grid);
library(plyr);
library(dplyr);

setwd("/Users/mengli/Documents/splicingSNP_new/");
source("src/R/multiplot.r");
source("src/R/get_roc_data.r");
all_data_filter<-sample_n(all_data_filter,nrow(all_data_filter) );

nLine<-as.integer(nrow(all_data_filter)/3*2);

all_data_train<-all_data_filter[1:nLine,];
all_data_test<-all_data_filter[(nLine+1):nrow(all_data_filter),];

#build random forest model.
modelrandomforest<-randomForest(formula=label~.,
                                data=all_data_train,
                                ntree=100,proximity=TRUE,
                                replace=FALSE,nodesize=19,mtry=12);

predictValues<-predict(modelrandomforest,all_data_test,type="prob")[,1];
names(predictValues)<-all_data_test[,"label"];

cutoffs <- get_roc_data(predictValues,"independent test","HGMD","NEUTRAL");
auc_value<-cutoffs[1,"auc"];

p1<-ggplot(cutoffs)+geom_ribbon(aes(x=fpr,ymin=0,ymax=tpr),fill="gray66")+ #geom_area(fill="green")+
  xlab("Fasle Positive Rate")+ylab("True Positive Rate")+theme_classic()+
  theme(text=element_text(size=7))+
  geom_text(aes(x=0.1,y=1.2), colour = "black", fontface = "bold",label="a  ",size = 4)+
  #geom_text(aes(x=0.5,y=1.2), colour = "black",size = 4,
  #label=paste0("Independent test (AUC=",signif(auc_value,3),")" ) );
  ggtitle(paste0("Independent test (AUC=",signif(auc_value,3),")" ) );


cutoffs2<-melt(cutoffs[,c("cut","tpr","fpr","f1","mcc")],"cut");
p2<-ggplot(cutoffs2) + geom_smooth(aes(x=cut,y=value,color=variable),linetype=1,size=0.5 ,se=FALSE)+
  geom_segment(aes(x = 0, y = 0.1, xend = 1, yend = 0.1) )+
  geom_segment(aes(x = 0.82, y = 0, xend = 0.82, yend = 1) )+
  #geom_segment(aes(x = 0, y = 0.4765, xend = 1, yend = 0.4765) )+
  geom_text(aes(x=0.06 ,y=0.16, label="y=0.1") )+
  scale_colour_discrete(name="Measures",
                        breaks=c("tpr", "fpr","f1","mcc"),
                        labels=c("True positive rate", "False positive rate","F1 Score","MCC"))+
  #xlim(0,1)+ylim(0,1)+
  xlab("cutoff")+theme_classic()+xlim(0,1)+ylim(0,1.2)+theme(text=element_text(size=7))+
  geom_text(aes(x=0.05,y=1.2), colour = "black", fontface = "bold",label="c  ",size = 4)+
  #geom_text(aes(x=0.5,y=1.2), colour = "black",size = 4,label="TPR,
  #FPR, F1 score and MCC change with cutoff" );
  #theme(legend.title=element_text("measures") );
  ggtitle("TPR, FPR, F1 score and MCC change with cutoff");

print(p2);


psi_percent<-c(0.054,0.083,0.167);
names(psi_percent)<-c("|PSI|>20%","10%<|PSI|<20%","|PSI|<10%");

psiData<-data.frame(percent=psi_percent,names=names(psi_percent) );
psiData[,"names"]<-factor(psiData[,"names"],levels=c("|PSI|>20%","10%<|PSI|<20%","|PSI|<10%"));

p3<-ggplot(psiData,aes(x=names,y=percent))+geom_bar(stat="identity") +theme_classic()+
  ylim(0,0.20)+theme(text=element_text(size=7))+
  geom_text(aes(x=0.6,y=0.197), colour = "black", fontface = "bold",label="b  ",size = 4)+
  scale_x_discrete(breaks=c("|PSI|>20%", "10%<|PSI|<20%", "|PSI|<10%"),
                   labels=c(expression(paste("|",Delta,Psi," |")>=20*paste("%") ), 
                            expression(10*paste("%")<=paste(" |",Delta,Psi,"|<20%") ),
                            expression(paste("|",Delta,Psi,"|<10%") )))+
  geom_text(aes(y=percent+1/80),label=sprintf("%1.1f%%",psi_percent*100 ) )+
  
  #geom_text(aes(x=2,y=0.19), colour = "black",size = 4, 
  #label="Percentile of high disease score (>0.91)\n in different PSI group" );
    ggtitle(expression(paste("Percentile of high disease score (>0.91) in different |",
                             Delta,Psi, "| group" ) ) )+xlab("");



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


