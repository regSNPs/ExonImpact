
bootstrapRandomForest<-function(data,bootstrapTime){
  allSampleIDs<-1:nrow(data);
  onePortionSize<-floor( length(allSampleIDs)/3 ); 
  
  sumRoc<-0;
  
  allProb<-c();
  allLabel<-c();
  
  for(i in 1:bootstrapTime){
    set.seed(1000);
    print(paste0("bootstrap number: ",i));
    testID<-sample(allSampleIDs,onePortionSize,replace=TRUE); 
    #allSampleIDs<-setdiff(allSampleIDs,testID); 
    trainID<-setdiff(  allSampleIDs,  testID  ); 
    
    
    modelrandomforest<-randomForest(formula=label~., 
                                    data=data[trainID,],ntree=100,mtry=12,
                                    proximity=TRUE,replace=FALSE,nodesize=19
    );
    
    #troc<-(roc( (data[testID,])$label, predict(modelrandomforest,data[testID,],type="prob")[,1] )$auc) [1];
    prob<-predict(modelrandomforest,data[testID,],type="prob")[,1]; 
    label<-(data[testID,])$label; 
    
    allProb<-c(allProb,prob) ; 
    allLabel<-c(allLabel,as.character(label) ) ; 
    
    #sumRoc<-sumRoc+troc;
  } 
  return(data.frame(prob=allProb,label=allLabel  )  ); 
  #return (sumRoc/crossNum);
}
