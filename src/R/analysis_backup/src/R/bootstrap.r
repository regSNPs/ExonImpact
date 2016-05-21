
bootstrapRandomForest<-function(data,bootstrapTime){
  allSampleIDs<-1:nrow(data);
  onePortionSize<-floor( length(allSampleIDs)/3 ); 
    
  allProb<-rep(1,onePortionSize*bootstrapTime);
  allLabel<-rep(1,onePortionSize*bootstrapTime);
  
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
    
    prob<-predict(modelrandomforest,data[testID,],type="prob")[,1]; 
    label<-as.character(data[testID,"label"]); 
    
    t=i-1;
    allProb[(t*onePortionSize+1):((t+1)*onePortionSize)]<-prob;
    allLabel[(t*onePortionSize+1):((t+1)*onePortionSize)]<-label;
  } 
  names(allProb)<-allLabel;
  return(allProb);
  #return(data.frame(prob=allProb,label=allLabel  )  ); 
  #return (sumRoc/crossNum);
}

