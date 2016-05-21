crossValidateRandomForest<-function(data,crossNum=10){
  allSampleIDs<-1:nrow(data);
  onePortionSize<-floor( length(allSampleIDs)/crossNum ); 
  
  allProb<-rep(1,onePortionSize*crossNum);
  allLabel<-rep(1,onePortionSize*crossNum);
  
  for(i in 1:crossNum){
    set.seed(1000);
    testID<-sample(allSampleIDs,onePortionSize,replace=FALSE); 
    print(paste0("cross-validate number: ",i) );
    
    allSampleIDs<-setdiff(allSampleIDs,testID); 
    trainID<-setdiff(  1:nrow(data),  testID  ); 
    
    modelrandomforest<-randomForest(formula=label~., 
                                    data=data[trainID,],ntree=100,mtry=12,
                                    proximity=TRUE,replace=FALSE,nodesize=19
    );
    
    prob<-predict(modelrandomforest,data[testID,],type="prob")[,1]; 
    label<-as.character(data[testID,"label"]); 
    
    t=i-1;
    allProb[(t*onePortionSize+1):((t+1)*onePortionSize)]<-prob;
    allLabel[(t*onePortionSize+1):((t+1)*onePortionSize)]<-label;
  } 
  names(allProb)<-allLabel;
  return(allProb);
  #return(data.frame(prob=allProb,label=allLabel  )  );
}
