#library(RJDBC)
library(plyr)
#library(data.table)
#这个文件主要是处理VCF文件的，包括各种各样的功能，是一个库文件被调用的。
#filter by 1000 genome
#main class and method


setClass("VCF",
         representation(chr="character",
                        pos="integer",
                        id="character",
                        ref="character",
                        alt="character",
                        qual="character",
                        filter="character",
                        info="character",
                        format="character",
                        samples="data.frame"
         ),
         
         
         prototype=prototype(chr="",
                             pos=integer(1),
                             id="",
                             ref="",
                             alt="",
                             qual="",
                             filter="",
                             info="",
                             format="",
                             samples=data.frame() )
         
);

#read the snp from VCF file
setGeneric("readFromVCFFile",function(object,filename){})
setMethod("readFromVCFFile","VCF",function(object,filename){
  dataFile<-readLines(filename);  
  n=1;
  names<-""
  for(i in 1:length(dataFile)){
    n=n+1;
    if(grepl("^##",dataFile[i]))
      next;
    
    if(grepl("^#",dataFile[i])){
      names<-strsplit(dataFile[i],split="\t")[[1]];
      break;
    }
    
  }
  if(n==(length(dataFile) +1) ){
    n=1;
  }
  if(names==""){
    names<-seq(1:length(strsplit(dataFile[1],"\\t")[[1]]))
  }
  
  data<-matrix(ncol=length(names),nrow=(length(dataFile)-n+1) );
  colnames(data)<-names;
  
  
  dataFile<-dataFile[n:length(dataFile)];
  
  arr<-strsplit(dataFile,split="\t");
  #cat(class(arr))
  
  for(i in 1:length(arr))
    data[i,]<-arr[[i]];
  
  
  dataf<-as.data.frame(data,stringsAsFactors=F);
  object<-buildFromDataframe(object,dataf);
  
  return(object);
  
})

#setGeneric("as.data.frame",function(object){})
#setMethod("as.data.frame",signature(x="VCF",row.names="ANY",optional="ANY"),
setMethod("as.data.frame",signature(x="VCF"),
          function(x,row.names=NULL,optional=NULL){
            
            result<-cbind(x@chr,x@pos,x@id,x@ref,x@alt,
                          x@qual,x@filter,x@info,x@format,
                          x@samples
            )
            
            return(result)
          })

setGeneric("buildFromDataframe",function(object,data){})
setMethod("buildFromDataframe","VCF",
          function(object,data){
            object@chr=data[,1];
            object@pos=as.integer(data[,2]);
            object@id=data[,3]
            object@ref=data[,4];
            object@alt=data[,5];
            object@qual=data[,6];
            object@filter=data[,7];
            object@info=data[,8];
            if(ncol(data)<9){
              cat("there are no samples here.");
              object@format=rep("",length(object@info));
              #object@samples=data.frame(nosample= rep("",length(object@info)) , stringsAsFactors=FALSE);     
              
              return(object);
              
            }
            
            object@format=data[,9];
            object@samples=data[,10:ncol(data)];     
            
            return(object);
            
          })

setGeneric("getSampleNames",function(object){})
setMethod("getSampleNames","VCF",
          function(object){
            return(colnames(object@samples));
            
            
          })

setGeneric("getDataFrame",function(object){})
setMethod("getDataFrame","VCF",
          function(object){
            dataf<- data.frame(
              chr=object@chr,
              pos=object@pos,
              id=object@id,
              ref=object@ref,
              alt=object@alt,
              qual=object@qual,
              filter=object@filter,
              info=object@info,
              format=object@format
              
            );
            if( length(object@samples)>0 )
            
            dataf<-cbind(dataf,object@samples);
            return(dataf);
            
          }
)

#setGeneric("[",function(object,index){})
setMethod("[", signature(x = "VCF", i = "numeric",j="missing",drop="ANY"), function(x,i,j=0,drop=FALSE){
  
  return(vcfSubset(x,i));
  
  
})

#setGeneric("filterBy1000genome",function(object){})
#setMethod("filterBy1000genome","VCF",function(object){
#  dataf<-getDataFrame(object);
#  
#  sqlStr<-paste(
#      "select pid from mergevcf INNER JOIN ensembl.variation ON(ensembl.variation.name=mergevcf.id)",
#      " where ensembl.variation.validation_status LIKE '%1000Genome%'",sep="");
#  
#  drv <- JDBC("com.mysql.jdbc.Driver","/home/limeng/Downloads/mysql-connector-java-5.1.31/mysql-connector-java-5.1.31-bin.jar",identifier.quote="`")
#  conn<-dbConnect(drv, "jdbc:mysql://111.117.59.63/drugresistant", "limeng", "880108")
#  
#  pid<-1:nrow(dataf);
#  dataf<-cbind(pid,dataf);


#  idTable<-data.frame(
#    pid<-1:nrow(dataf),
#    id<-dataf[,2]    
#    )
#  
#  colnames(idTable)<-c("id","pid");
#  dbWriteTable(conn, "mergevcf", idTable,overwrite=TRUE)
#  
#  #dbWriteTable(conn, "mergevcf", dataf, overwrite=TRUE)
#  res<-dbSendQuery(conn,sqlStr);
#  pid<-dbFetch(res);
#  dataf<-dataf[pid,-1];
#  
#  exceptionStr<-dbGetException(conn);
#  cat(exceptionStr);

#  mergeno1000Genome <- dbReadTable(conn, "mergeindelfilter1000genome")

#  return(buildFromDataframe(object,mergeno1000Genome));

#})

setGeneric("vcfSubset",function(object,subset){})
setMethod("vcfSubset","VCF",
          function(object,subset){
            object@chr=object@chr[subset];
            object@pos=as.integer(object@pos[subset]);
            object@id=object@id[subset]
            object@ref=object@ref[subset];
            object@alt=object@alt[subset];
            object@qual=object@qual[subset];
            object@filter=object@filter[subset];
            object@info=object@info[subset];
            object@format=object@format[subset];
            if(nrow(object@samples)<1 )
              return(object);
            
            object@samples=object@samples[subset,];   
            
            return(object);
          })

setGeneric("vcfGetAttribute",function(object,column){})
setMethod("vcfGetAttribute","VCF",
          function(object,column){
            geneNamePattern<-paste(column,"[^;]*;",sep="");
            str<-regexpr(geneNamePattern,object@info)
            begPos=str[1:length(str)];
            endPos=attr(str,"match.length");
            attrs<-c();
            for(i in 1:length(str)){
              attrs<-c(attrs,substr(object@info[i],begPos[i]+nchar(column)+1,begPos[i]+endPos[i]-1-1) ) ; 
              
            }
            
            return(attrs);
          })

setGeneric("vcfFilterByAttr",function(object,pattern){})
setMethod("vcfFilterByAttr","VCF",
          function(object,pattern){
            inPattern<-grepl(pattern,object@info);
            subset<-vcfSubset(object,inPattern);
            
            return(subset);
})


setGeneric("vcfGetAttributeFunc",function(object,x){})
setMethod("vcfGetAttributeFunc","VCF",function(object,x){
  geneNamePattern<-paste(";",x,"[^;]*;",sep="");
  str<-regexpr(geneNamePattern,info)#str是向量。
  begPos=str[1:length(str)];
  endPos=attr(str,"match.length");
  attrs<-c();
  for(i in 1:length(str)){
    attrs<-c(attrs,substr(info[i],begPos[i]+nchar(x)+1+1,begPos[i]+endPos[i]-1-1) ) ;
  }
  return(attrs);
})

#the snpMatrix 0 stand for don't have a snp here, 1 stand for having a snp here.
setGeneric("getSnpMatrix",function(object){})
setMethod("getSnpMatrix","VCF",
          function(object){
            #snpIndels<-object@samples;
            snpIndels<-apply(object@samples,c(1,2),function(x){return(as.integer(grepl("\\.",x))); } )
            
            snpIndels<-as.data.frame(snpIndels,row.names=1:nrow(snpIndels))
            #cat(class(snpIndels))
            #snpIndelDis<-cbind(attrs,snpIndels);
            return(snpIndels);
            
          }
)

setGeneric("distributionInGenes",function(object,column){})
setMethod("distributionInGenes","VCF",
          function(object,column){
            attrs<-vcfGetAttribute(object,column);
            #attrs<-as.factor(attrs);
            #snpIndels<-apply(object@samples,c(1,2),function(x){return(as.integer(grepl("\\.",x))); } )
            #snpIndels<-as.data.frame(snpIndels,row.names=1:nrow(snpIndels))
            #cat(class(snpIndels))
            snpIndelDis<-getSnpMatrix(object);
            snpIndelDis<-cbind(attrs,snpIndelDis);
            
            snpIndelDis<-aggregate(snpIndelDis[-1],by=list(snpIndelDis$attrs) ,sum)
            return(snpIndelDis);
          }
)

setGeneric("rmSample",function(object,samplename){})
setMethod("rmSample","VCF",function(object,samplename){
  object@samples=object@samples[,colnames(object@samples)!=samplename];
  
  return(object);
  
})

setGeneric("oderBySample",function(object,samplenames){})
setMethod("oderBySample","VCF",function(object,samplenames){
  object@samples<-object@samples[,samplenames]
  
  return(object);
  
})

setGeneric("rmIndel",function(object){})
setMethod("rmIndel","VCF",function(object){
  #resut<-c()
  result<-apply(cbind(object@ref,object@alt),1,
                function(x){if((nchar(x[1])==1)&&(nchar(x[2])==1)) return(TRUE);return(FALSE)});
  
  return(vcfSubset(object,result));
  
})

setGeneric("rmSNP",function(object){})
setMethod("rmSNP","VCF",function(object){
  result<-apply(cbind(object@ref,object@alt),1,
                function(x){if((nchar(x[1])==1)&&(nchar(x[2])==1)) return(FALSE);return(TRUE)});
  
  return(vcfSubset(object,result));
  
})

setMethod("length","VCF",
          function(x){
            return(length(x@chr))
            
          })


setGeneric("filterVCF",function(object,column){})
setMethod("filterVCF","VCF",
          function(object,column){
            result<-sapply(object@filter,function(x){ if(x==column) return(TRUE); return(FALSE)});
            
            return(vcfSubset(object,result))
          })


setGeneric("snpLevelUnparametric",function(object,drug){})
setMethod("snpLevelUnparametric","VCF",
          function(object,drug){
            
            snpIndelDis<-getSnpMatrix(object);
            result<-apply(snpIndelDis,1,
                          function(snp,drug){
                            Group1<-c()
                            Group2<-c()
                            for(i in 1:length(snp)){
                              if(snp[i]==1)
                                Group1<-c(Group1,drug[i]);
                              if(snp[i]==0)
                                Group2<-c(Group2,drug[i]);
                            }
                            
                            if(length(Group1)<2)
                              return("WRONG");
                            
                            if(length(Group2)<2)
                              return("WRONG");
                            
                            if(min(Group1)>max(Group2))
                              return( paste(length(Group1),length(Group2)," ",max(Group1),":",min(Group2) ,sep="")  )
                            if(max(Group1)<min(Group2))
                              return( paste(length(Group1),length(Group2)," ",min(Group1),":",max(Group2) ,sep="")  )
                            
                            return("WRONG");
                            
                          },drug );
            
            targetSnpIndelsMatrix<-snpIndelDis[which(result!="WRONG"),]
            #targetNames<-rownames(targetSnpIndelsMatrix)
            #return(targetSnpIndelsMatrix)
            targetSnpIndel<-vcfSubset(object,which(result!="WRONG"));
            
            resultOfDrug<-data.frame(
              chr=targetSnpIndel@chr,
              pos=targetSnpIndel@pos,
              ref=targetSnpIndel@ref,
              alt=targetSnpIndel@alt,
              RatioAndBounding=result[which(result!="WRONG")]
            )
            
            #return(result);
            return(resultOfDrug);
            
          })


setGeneric("snpGroupAnalysis",function(object,group1,group2){})
setMethod("snpGroupAnalysis","VCF",
          function(object,group1,group2){
            snpIndelDis<-getSnpMatrix(object);
            
            group1SnpIndel<-snpIndelDis[,group1,drop=FALSE];
            group2SnpIndel<-snpIndelDis[,group2,drop=FALSE];
            
            minGroup1<-apply(group1SnpIndel,1,min);
            maxGroup1<-apply(group1SnpIndel,1,max);
            minGroup2<-apply(group2SnpIndel,1,min);
            maxGroup2<-apply(group2SnpIndel,1,max);
            
            sg1<-(minGroup1>maxGroup2)
            sg2<-(minGroup2>maxGroup1)
            
            result<-sg1|sg2;
            
            return(vcfSubset(object,result));
            
          })


setGeneric("geneLevelSpearman",function(object,column,drug){})
setMethod("geneLevelSpearman","VCF",
          function(object,column,drug){
            attrs<-vcfGetAttribute(vcf,"Gene");
            
            snpDisInGenes<-distributionInGenes(object,column);
            spearmanResult<-apply(snpDisInGenes[-1],1,function(x){return(cor(x,drug,method="spearman")) });
            geneLevelSpearman<-cbind(snpDisInGenes,spearmanResult)
            geneLevelSpearman<-geneLevelSpearman[order(abs(geneLevelSpearman[ncol(geneLevelSpearman)]),decreasing=TRUE),]
            return(geneLevelSpearman);
            
          }
)


