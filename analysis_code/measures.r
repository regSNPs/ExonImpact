
tprFun<-function(x,predictValues,positive_label,negative_label){
  t<-sum(predictValues[names(predictValues)==positive_label]>x)/sum(names(predictValues)==positive_label);
  return(t);
}

fprFun<-function(x,predictValues,positive_label,negative_label){
  t<-sum(predictValues[names(predictValues)==negative_label]>x)/sum(names(predictValues)==negative_label);
  return(t);
}

f1Fun<-function(x,predictValues,positive_label,negative_label){
  tp<-sum(predictValues[names(predictValues)==positive_label]>x); #tp
  fp<-sum(predictValues[names(predictValues)==negative_label]>x); #fp
  fn<-sum(predictValues[names(predictValues)==positive_label]<x); #fn
  f1<-(2*tp)/(2*tp+fp+fn);
  
  return(f1);
}

fdrFun<-function(x,predictValues,positive_label,negative_label){
  t<-sum(predictValues[names(predictValues)==negative_label]>x)/sum(predictValues>x); #fdr
}

mccFun<-function(x,predictValues,positive_label,negative_label){
  tp<-sum(predictValues[names(predictValues)==positive_label]>x);   #tp
  tn<-sum(predictValues[names(predictValues)==negative_label]<x);   #tp
  fp<-sum(predictValues[names(predictValues)==negative_label]>x);   #fp
  fn<-sum(predictValues[names(predictValues)==positive_label]<x);   #fn
  #print( paste0(tp," ",tn," ",fp," ",fn,"\n") );
  
  mcc<-( (tp*tn)-(fp*fn) )/( sqrt(tp+fp)*sqrt(tp+fn)*sqrt(tn+fp)*sqrt(tn+fn) ); 
  return(mcc);
}

get_auc<-function(predictValues,positive_label,negative_label){
  auc<-mean(sample(predictValues[names(predictValues)==positive_label],1000000,replace=TRUE) >
              sample(predictValues[names(predictValues)==negative_label],1000000,replace=TRUE) );
  return(auc);
}

