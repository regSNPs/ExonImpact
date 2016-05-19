dir<-"/N/dc2/projects/ngs/liulab_raox/GTEX_brain_from_hongyu/miso_results/";
dirs<-list.dirs(path=dir,full.names=F,recursive=F)

result<-c();

unlink("miso_merge.tsv");
for(i in 1:length(dirs) ){
  tryCatch({
    fileName<-paste(dir,dirs[i],"/miso_output/summary/miso_output.miso_summary",sep="");
    sampleName<-substr(dirs[i],1,(nchar(dirs[i])-2) );
    print(paste0(sampleName,"\n") );
    miso_summary<-read.table( fileName,header=TRUE,sep="\t",as.is=TRUE );
    miso_summary_sample<-cbind(sampleName,miso_summary[,1:4]);
    #writeLines(miso_summary_sample,con="",sep="\n");
    #result<-c(result,miso_summary_sample);
    cat(paste("current file is:",i,"\n"));
    write.table(miso_summary_sample,file="miso_merge.tsv",sep="\t",append=TRUE,row.names=FALSE,col.names=FALSE)

  },
  error=function(cond){message(cond)}
  )

}

#writeLines(result,con="miso_merge.tsv");
