crossValidateRandomForest<-function(data,crossNum=10){
  allSampleIDs<-1:nrow(data);
  onePortionSize<-floor( length(allSampleIDs)/crossNum ); 
  
  allProb<-c();
  allLabel<-c();
  
  for(i in 1:crossNum){
    set.seed(1000);
    testID<-sample(allSampleIDs,onePortionSize,replace=FALSE); 
    allSampleIDs<-setdiff(allSampleIDs,testID); 
    trainID<-setdiff(  1:nrow(data),  testID  ); 
    
    modelrandomforest<-randomForest(formula=label~., 
                                    data=data[trainID,],ntree=100,mtry=12,
                                    proximity=TRUE,replace=FALSE,nodesize=19
    );
    
    prob<-predict(modelrandomforest,data[testID,],type="prob")[,1]; 
    label<-(data[testID,])$label; 
    
    allProb<-c(allProb,prob);
    allLabel<-c(allLabel,as.character(label) );
    
  } 
  return(data.frame(prob=allProb,label=allLabel  )  );
}
