path_to_spinex<-"E:\\limeng\\splicingSNP\\exon_impact_new\\combined_spXout\\";
spinex_files<-list.files(path_to_spinex,pattern="*.spXout$");

#spine_x_ret<-data.frame(beta_sheet=c(),random_coil=c(),alpha_helix=c(),asa=c(),stringsAsFactors =FALSE);
spine_x_ret<-matrix(nrow=0,ncol=6);

file<-"NM_017883.spXout";
for(file in spinex_files){
  #print(file);
  tryCatch({
    spinex_data<-read.table(paste0(path_to_spinex,file),header=FALSE,as.is=TRUE );
    
    transcript_id<-sapply(strsplit(file,"\\."),"[",1);
    
    aa<-paste(spinex_data[,2],collapse="," );
    beta_sheet<-paste(spinex_data[,6],collapse="," );
    random_coil<-paste(spinex_data[,7],collapse="," );
    alpha_helix<-paste(spinex_data[,8],collapse="," );
    asa<-paste(spinex_data[,11],collapse="," );
    
    spine_x_ret<-rbind(spine_x_ret,c(transcript_id,aa,beta_sheet,random_coil,alpha_helix,asa) );
    
    },error=function(e){
      print(paste0("The file has problem is: ",e,"\t",file) );
    },warning=function(e){
      print(paste0("The file has problem is: ",e,"\t",file) );
    })
}
colnames(spine_x_ret)<-c("transcript_id","amino_acid","beta_sheet","random_coil","alpha_helix","asa");
spine_x_ret_frame<-as.data.frame(spine_x_ret,stringsAsFactors=FALSE);


path_to_spined<-"E:\\limeng\\splicingSNP\\exon_impact_new\\spineD_disorderScore\\";
spined_files<-list.files(path_to_spined,patter="*.spd$");


spine_d_ret<-matrix(nrow=0,ncol=3);

for(file in spined_files){
  tryCatch({
    
  spined_data<-read.table(paste0(path_to_spined,file),header=FALSE );
  
  transcript_id<-sapply(strsplit(file,"\\."),"[",1);
  
  aa<-paste(spined_data[,1],collapse=",");
  disorder<-paste(spined_data[,3],collapse=",");
  
  spine_d_ret<-rbind(spine_d_ret,c(transcript_id,aa,disorder) );
  },error=function(e){
    print(paste0("The file has problem is: ",e,"\t",file) );
  },warning=function(e){
    print(paste0("The file has problem is: ",e,"\t",file) );
  });
  
}
colnames(spine_d_ret)<-c("transcript_id","amino_acid","disorder");
spine_d_ret_frame<-as.data.frame(spine_d_ret,stringsAsFactors=FALSE);

library(dplyr)
spine_dx_ret<-inner_join(spine_d_ret_frame,spine_x_ret_frame,by=c("transcript_id"="transcript_id") );

spine_dx_ret<-spine_dx_ret[,-4];
spine_dx_ret<-spine_dx_ret[,c("transcript_id","amino_acid.x","beta_sheet","random_coil","alpha_helix","asa","disorder")]
#setwd("E:\\limeng\\splicingSNP\\exon_impact_new\\")
write.table(spine_dx_ret,file="spine_x_d_combine.tsv",sep="\t",quote=FALSE,row.names=FALSE);

