source("src/R/measures.r");

get_roc_data<-function(predictValues,title,positive_label,negative_label){
  
  thresholds<-seq(-0.1,1.1,0.02);

  tpr<-sapply(thresholds,tprFun,predictValues,positive_label,negative_label);
  fpr<-sapply(thresholds,fprFun,predictValues,positive_label,negative_label);
  f1<- sapply(thresholds,f1Fun,predictValues,positive_label,negative_label);
  fdr<-sapply(thresholds,fdrFun,predictValues,positive_label,negative_label);
  mcc<-sapply(thresholds,mccFun,predictValues,positive_label,negative_label);
  
  auc<-get_auc(predictValues,positive_label,negative_label);
  
  cutoffs <- data.frame(cut=thresholds, tpr=tpr, fpr=fpr,f1=f1,fdr=fdr,mcc=mcc,auc=rep(auc,length(tpr) )  );
  write.csv(cutoffs,file=paste0("result/",title,"_cutoff.csv"),quote=FALSE,row.names=FALSE);
  #plot(x=fpr,y=tpr,xlab="False Positive Rate",ylab="True Positive Rate",type="l",main=paste0(title," AUC: ",aucValue) );
  #ggplot()+geom_line(aes(x=fpr,y=tpr))+xlab("False Positive Rate")+ylab("True Positive Rate")
  return(cutoffs);
  #abline(0,1);
  
}

