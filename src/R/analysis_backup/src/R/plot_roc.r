
plot_roc<-function(predictValues,title){
  tprFun<-function(x){
    t<-sum(predictValues[predictValues$label=="HGMD","prob"]>x)/sum(predictValues$label=="HGMD");
    return(t);
  }
  
  fprFun<-function(x){
    t<-sum(predictValues[predictValues$label=="NEUTRAL","prob"]>x)/sum(predictValues$label=="NEUTRAL");
    return(t);
  }

  f1Fun<-function(x){
    tp<-sum(predictValues[predictValues$label=="HGMD","prob"]>x );   #tp
    fp<-sum(predictValues[predictValues$label=="NEUTRAL","prob"]>x); #fp
    fn<-sum(predictValues[predictValues$label=="HGMD","prob"]<x);    #fn
    f1<-(2*tp)/(2*tp+fp+fn);
  
    return(f1);
  }

  fdrFun<-function(x){
    t<-sum(predictValues[predictValues$label=="NEUTRAL","prob"]>x)/sum(predictValues>x); #fdr
  }

  mccFun<-function(x){
    tp<-sum(predictValues[predictValues$label=="HGMD","prob"]>x );      #tp
    tn<-sum(predictValues[predictValues$label=="NEUTRAL","prob"]<x );   #tp
    fp<-sum(predictValues[predictValues$label=="NEUTRAL","prob"]>x);    #fp
    fn<-sum(predictValues[predictValues$label=="HGMD","prob"]<x);       #fn
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
  
  
  cutoffs <- data.frame(cut=thresholds, tpr=tpr, fpr=fpr,f1=f1,fdr=fdr,mcc=mcc );
  write.csv(cutoffs,file=paste0("result/",title,"_cutoff.csv"),quote=FALSE,row.names=FALSE);
  
  aucValue<-mean(sample(predictValues[predictValues$label=="HGMD","prob"],1000000,replace=TRUE) >
                   sample(predictValues[predictValues$label=="NEUTRAL","prob"],1000000,replace=TRUE) );
  
  cat(paste("\nAUC=",aucValue,"\n")  );
  aucValue<-format(aucValue,digits=3)
  
  #plot(x=fpr,y=tpr,xlab="False Positive Rate",ylab="True Positive Rate",type="l",main=paste0(title," AUC: ",aucValue) );
  #ggplot()+geom_line(aes(x=fpr,y=tpr))+xlab("False Positive Rate")+ylab("True Positive Rate")
  return(data.frame(fpr=fpr,tpr=tpr) );
  #abline(0,1);
  
}



