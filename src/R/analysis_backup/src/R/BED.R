library(GenomicRanges)
library(stringr)

setClass("BED",
         representation(chrom="character",
                        chromStart="integer",
                        chromEnd="integer",
                        name="character",
                        score="numeric",
                        strand="character",
                        thickStart="integer",
                        thickEnd="integer",
                        itemRgb="integer",
                        blockCount="integer",
                        blockSizes="list",
                        blockStarts="list"
                        
         ),
         prototype=prototype(
               chrom="",
               chromStart=integer(0),
               chromEnd=integer(0),
               name="",
               score=numeric(0),
               strand="character",
               thickStart=integer(0),
               thickEnd=integer(0),
               itemRgb=integer(0),
               blockCount=integer(0),
               blockSizes=list(),
               blockStarts=list()
             
           )
         
)

#read data from a bed file,only keep the chr1-22,X,Y
setGeneric("readFromBedFile",function(object,bedFileName){} )
setMethod("readFromBedFile",signature(object="BED",bedFileName="character"),function(object,bedFileName){
  bedData<-read.table(bedFileName,header=FALSE,as.is=TRUE);
  cat("read data from a bed file,only keep the chr1-22,X,Y\n")
  bedHeaderNames<-c("chrom","chromStart","chromEnd",
                    "name","score","strand","thickStart",
                    "thickEnd","itemRgb","blockCount",
                    "blockSizes","blockStarts");
  
  bedNames<-bedHeaderNames[1:ncol(bedData)];
  colnames(bedData)<-bedNames;
  
  chrLabel<-grepl("chr[1-9,x,y]$|chr1[0-9]$|chr2[0-2]$|chr[1-9,X,Y]",bedData[,1]);
  cat("only chr1-22,X,Y are include\n");
  
  bedData<-bedData[chrLabel,];
  
  for(i in 1:length(bedNames)){
    cat(paste("bed filed: ",bedNames[i],"\n",sep="") )
    if((bedNames[i]=="blockStarts")||(bedNames[i]=="blockSizes")){
      p<-strsplit(bedData[,bedNames[i]],",");
      p<-sapply(p,as.numeric);
      slot(object,bedNames[i]) <-p;
      
    }else{
      slot(object,bedNames[i]) <-bedData[,bedNames[i]]
    }
  }
  
  return(object)
  
})

#get the exons of a transcript, each exon's format: chr:beg:end
setGeneric("getTranscriptExons",function(object,transcriptID){})
setMethod("getTranscriptExons",signature(object="BED",transcriptID ="character") ,function(object,transcriptID){
  line=which(object@name==transcriptID)
  #cat(str_c("line:",line,"/n"))
  #cat(str_c("transcript start:",object@chromStart[[line]],"\n" ))
  #the exons
  if(length(line)==0)
    return(NA);
  #there are replicate in RefSeq database, so keep a  random one(here the first one);
  if(length(line)>1)
    line=line[1];
  
  result<-getExonsOfLine(object,line);
  
  return(result);
})

# get region of a exon,  each exon's format: chr:beg:end
setGeneric("getExonRegion",function(object,transcriptID,exonIndex){})
setMethod("getExonRegion",signature(object="BED",transcriptID ="character",exonIndex="numeric"),
          function(object,transcriptID,exonIndex){
  a<-getTranscriptExons(object,transcriptID);
  
  if( sum(!is.na(a))==0 )
    return("");
  
  return(a[exonIndex] );
  
})

# get exon regions,  each exon's format: chr:beg:end
setGeneric("getExonsRegion",function(object,transcriptID,exonIndex){})
setMethod("getExonsRegion",signature(object="BED",transcriptID ="character",exonIndex="numeric"), 
          function(object,transcriptID,exonIndex){
  resultExons<-c();
  
  for(i in 1:length(transcriptID)){
    #cat(str_c("current transcript ID:",transcriptID[i],"\n"))
    a<-getExonRegion(object,transcriptID[i],exonIndex[i] );
    if(is.na(a)){
      resultExons<-c(resultExons, "");
      
    }else{
    
      resultExons<-c(resultExons, a);
    }
    
  }
  
  #remove the NA, NA is due to the fact that different annotation or annotation changing.
  resultExons<-resultExons[!is.na(resultExons)];
  
  return(resultExons);
  #return(getTranscriptExons(object,transcriptID)[exonIndex] );
  
})

#get exons of line, each exon's format: chr:beg:end
setGeneric("getExonsOfLine",function(object,line){})
setMethod("getExonsOfLine",signature(object="BED",line="numeric"),function(object,line){
  if(line>length(object@chrom)||line<1 )
    return(NA);
    
  #cat(str_c("line:",line))
  exonStarts<-object@blockStarts[[line]]+object@chromStart[[line]]+1;
  exonEnds<-exonStarts+object@blockSizes[[line]]-1;
  chr<-object@chrom[line];
  #strand<-object@strand[line];
  
  #cat(str_c("exon count:",object@blockCount[[line]]))
  #cat(str_c("exon sizes:",object@blockSizes[[line]]))
  strand=object@strand[line];
  
  result<-str_c(chr,":",exonStarts,":",exonEnds,":",strand);
  if(strand=="-")
    result<-rev(result);
  
  
  return(result);
  
})



setGeneric("generatingIntronSplicingRegion",
           function(object,rightIntronLength,
                    leftExonLength,leftIntronLength,rightExonLength){})
setMethod("generatingIntronSplicingRegion",
          signature(object="BED",rightIntronLength="integer",leftExonLength="integer",
                    leftIntronLength="integer",rightExonLength="integer"),
          function(object, rightIntronLength,leftExonLength,
                   leftIntronLength,rightExonLength){
#generatingIntronSplicingRegion<-function(bedFileName,rightIntronLength,leftExonLength,leftIntronLength,rightExonLength){
  #bedData<-read.table(bedFileName,header=FALSE,as.is=TRUE);
  #colnames(bedData)<-c("chr","start","end","id","score","strand",
            #"thickStart","thickEnd","color","blockCount","blockSizes","blockStart");
  
  #intronSplicingRegion<-list();
  leftExonLength<-leftExonLength-1;
  rightExonLength<-rightExonLength-1;
  
  #chrom="",
  #chromStart=integer(0),
  #chromEnd=integer(0),
  #name="",
  #score=numeric(0),
  #strand="character",
  #thickStart=integer(0),
  #thickEnd=integer(0),
  #itemRgb=integer(0),
  #blockCount=integer(0),
  #blockSizes=list(),
  #blockStarts=list()
  
  #chrs<-bedData[,"chr"];
  #exonStartPoss<-strsplit(bedData[,"blockStart"],",");  
  #sizes<-strsplit(bedData[,"blockSizes"],","); 
  #counts<-as.numeric(as.character(bedData[,"blockCount"]));
  #transcriptPoss<-bedData[,"start"];
  chrs<-chrom;
  exonStartPoss<-blockStarts;
  sizes<-blockSizes;
  counts<-blockCount;
  transcriptPoss<-chromStart;
  
  #rowNumber<-sum(counts);
  rowNumber<-0;
  for(i in 1:length(counts)){
    count<-counts[i]
    if(count<3)
      next;
    
    rowNumber=rowNumber+counts[i]-2;
    
  }
  
  
  intronSplicingRegion<- matrix(ncol=3,nrow=rowNumber*2);
  index=1;
  
  for(i in 1:length(chrom) ){
    #x<-bedData[i,];
    if(i%%100==1)
      cat(str_c(i,"\n"));
    
    chr<-chrs[i];
    start<-as.numeric(exonStartPoss[[i]])
    size<-as.numeric(sizes[[i]])
    count<-counts[i]
    transcriptStartPos<-transcriptPoss[i]
    
    end<-start+size-1;  
    exonEndPos<-end;
    
    transcriptStart<-start+transcriptStartPos+1
    transcriptEnd<-transcriptStartPos+end+1;
    
    #cat(str_c("exon count:",count,"\n"))
    
    for(j in 1:count){
      
      trightIntronLength<-rightIntronLength
      tleftExonLength<-leftExonLength
      tleftIntronLength<-leftIntronLength
      trightExonLength<-rightExonLength
      
      if(1==j)
        next;
      if(count==j)
        next;
      lastIntronLength=start[j]-end[j-1]+1;
      thisExonsLength=size[j];
      nextIntronLength=start[j+1]-end[j]+1;
      
      if(tleftIntronLength>lastIntronLength )
        tleftIntronLength=lastIntronLength
      
      if(trightExonLength>thisExonsLength)
        trightExonLength=thisExonsLength
      
      if(tleftExonLength>thisExonsLength)
        tleftExonLength=thisExonsLength  
      
      if(trightIntronLength>nextIntronLength)
        trightIntronLength=nextIntronLength
      
      
      stopifnot(leftExonLength<=2);
      #here -1 means convert to bed format
      intronSplicingRegion[index,] <- c(chr,transcriptStart[j]-1-tleftIntronLength,transcriptStart[j]-1+trightExonLength);
      index=index+1;
      intronSplicingRegion[index,] <- c(chr,transcriptEnd[j]-1-tleftExonLength,transcriptEnd[j]-1+trightIntronLength);
      index=index+1;
      
      #intronSplicingRegion[index,] <- c(chr,transcriptStart[j]-tleftIntronLength,transcriptStart[j]+trightExonLength);
      #index=index+1;
      #intronSplicingRegion[index,] <- c(chr,transcriptEnd[j]-tleftExonLength,transcriptEnd[j]+trightIntronLength);
      #index=index+1;
      
    }
    
  }
  
  #return(intronSplicingRegion);
  
  #post sort and processing,sort and annotation
  intronBed<-data.frame(intronSplicingRegion[,1],as.numeric(intronSplicingRegion[,2]),
                        as.numeric(intronSplicingRegion[,3]),stringsAsFactors =FALSE);
  
  intronBedunique<-unique(intronBed);
  intronBedSort<-intronBedunique[order(intronBedunique[,1],intronBedunique[,2],intronBedunique[,3]),  ]
  
  #intronBedSort<-cbind(intronBedSort)
  #colnames(intronBedSort)<-c("chrom","chromStart","chromEnd","name","score",
  #"strand","thickStart","thickEnd","itemRgb","blockCount","blockSizes","blockStarts");
  colnames(intronBedSort)<-c("chrom","chromStart","chromEnd")
  
  #delete "chr" in exons
  cat(str_c("number of bed's chrosome doesn't begin with 0",sum(!str_detect(intronBedSort[,1],"chr") ) )  );
  
  if(sum(!str_detect(intronBedSort[,1],"chr") )==0)
    intronBedSort[,1]<-str_sub(intronBedSort[,1],4)
  
  return(intronBedSort);
  
})


#get all exon corrdinate except the first and last exon,each exon's format: chr:beg:end
setGeneric("getAllExonCoordinate",function(object){})
setMethod("getAllExonCoordinate",signature(object="BED"),function(object){
  cat("get all exon corrdinate except the first and last exon,each exon's format: chr:beg:end\n");
  
  totalExonsNumber<-sum(sapply(object@blockCount,function(x){ifelse(x>2,x,0)})  )
  resultExons<-vector(mode = "character", length = totalExonsNumber);
  cat(str_c("total of exons except first and last exon:",totalExonsNumber))
  
  j=1;
  for(i in 1:length(object@chrom)){
    #exclude the exons number <3
    transcriptExons<-getExonsOfLine(object,i);
    if(length(transcriptExons)<3)
      next;
    
    #exclude the first and last exons
    transcriptExons<-transcriptExons[-1];#exclude the first exon
    transcriptExons<-transcriptExons[-length(transcriptExons)]#exclude the last exon
    
    resultExons[j:(j+length(transcriptExons)-1 ) ]<-transcriptExons;
    
    j=j+length(transcriptExons)
    
  }
  
  cat(str_c("total exons number before unique:",length(resultExons),"\n"))
  resultExons<-unique(resultExons);
  cat(str_c("total exons number after unique:",length(resultExons),"\n"))
  
  #remove possible zero length string, need check here !!!
  resultExons<-unique(resultExons);
  
  resultExons<-resultExons[nchar(resultExons)>0]
  return(resultExons);
  
})

#convert the bed object to data.frame
setGeneric("convertToDataframe",function(object){})
setMethod("convertToDataframe",signature(object="BED"),function(object){
  bedFrame<-data.frame(
    
  chrom=object@chrom,
  chromStart=object@chromStart,
  chromEnd=object@chromEnd,
  name=object@name,
  score=object@score,
  strand=object@strand,
  thickStart=object@thickStart,
  thickEnd=object@thickEnd,
  itemRgb=object@itemRgb,
  blockCount=object@blockCount,
  blockSizes=sapply(object@blockSizes,function(x){paste(x,collapse=",")  }) ,
  #blockStarts=paste(object@blockStarts,collapse=",") )
  blockStarts=sapply(object@blockStarts,function(x){paste(x,collapse=",")  }),
  
  stringsAsFactors=FALSE
  )
  
  return(bedFrame);
})

# convert the object to a GenomicRange object
setGeneric("convertToGenomicRange",function(object){})
setMethod("convertToGenomicRange",signature(object="BED"),function(object){
  bedData<-convertToDataframe(object);
  bed <- with(bedData, GRanges(chrom, IRanges(chromStart, chromEnd),strand,name,blockCount,blockSizes,blockStarts) );
  
  
  return(bed);
})

setGeneric("getGeneIdFromSnp",function(object,snp){ })
setMethod("getGeneIdFromSnp",signature(object="BED",snp="data.frame"),function(object,snp){
  stopifnot( is.character(snp[,1])&&is.numeric(snp[,2]) );
  
  
  chr<-ifelse(!str_detect(snp[,1],"^chr"),
              str_c("chr",snp[,1]),
              snp[,1]);
  
  pos<-snp[,2];
  #strand<-snp[,3];
  strand<-rep("*",length(chr )  )
  #cat(chr)
  #cat(pos)
  # convert snps and transcripts to GenomicRanges
  vcf<-GRanges(chr, IRanges(pos, pos),strand );
  
  bed<-convertToGenomicRange(object);
  cat(mcols(bed)$strand)
  #find the overlap between the transcirpts and snps
  vcfhits<-findOverlaps(vcf,bed);
  wrongAnnotationSNPs<-snp[-unique(queryHits(vcfhits))];
  cat(str_c("!!can't map on bed transcripts:",
            wrongAnnotationSNPs,"\n") );
  
  bedFrame<-as(bed[subjectHits(vcfhits)],"data.frame");
  
  return(bedFrame[,"name"]);
  
});


#snp's format: data.frame column 1: chr, column 2: position, each exon's format chr:beg:end
setGeneric("getNearestExons",function(object,snp,threshold){  })
setMethod("getNearestExons",
          signature(object="BED",snp="data.frame",threshold="numeric"),
          function(object,snp,threshold){
  #snp<-read.table(snpFileName,header=TRUE,as.is=TRUE);
  chr<-ifelse(!str_detect(snp[,1],"^chr"),
    str_c("chr",snp[,1]),
    snp[,1])
  
  pos<-snp[,2];
  strand<-snp[,3];
  
  #cat(chr)
  #cat(pos)
  # convert snps and transcripts to GenomicRanges
  vcf<-GRanges(chr, IRanges(pos, pos),strand);
  
  bed<-convertToGenomicRange(object);
  #cat(mcols(bed)$strand)
  #find the overlap between the transcirpts and snps
  vcfhits<-findOverlaps(vcf,bed);
  wrongAnnotationSNPs<-snp[-unique(queryHits(vcfhits))];
  if(!is.null(wrongAnnotationSNPs)){
    cat("!!can't map on bed transcripts:\n");
    write.csv(wrongAnnotationSNPs);
  }
  #get hited snp information
  vcfFrame<-as(vcf[queryHits(vcfhits)],"data.frame");
  #get hited transcript information
  bedFrame<-as(bed[subjectHits(vcfhits)],"data.frame");
  
  #make snp and bed colnames different
  colnames(vcfFrame)<-str_c("snp",colnames(vcfFrame));
  colnames(bedFrame)<-str_c("bed",colnames(bedFrame));
  #
  vcfbed<-cbind(vcfFrame,bedFrame);
  #cat(str_c("the first line in VCFBED:",vcfbed[1,]) )
  
  #write.csv(vcfbed)
  bedblockStarts<-strsplit(as.character(vcfbed[,"bedblockStarts"]),",");
  bedblockSizes<-strsplit(as.character(vcfbed[,"bedblockSizes"]),",");
  #bedblockEnds<-bedblockStarts+as.numeric(strsplit(as.character(vcfbed[,"bedblockSizes"]),","))-1;
  
  #cat(colnames(vcfbed)) 
  targetExons<-c();
  targetExonsAndSNPs<-matrix(ncol=6,nrow=0);
  
  #result<-apply(vcfbed,1,function(x,desc){
  for(i in 1:nrow(vcfbed)){
    x<-vcfbed[i,]
    
    if(is.na(x[1,1]) )
      next;
    #cat(str_c("class of vcfbed line:",class(x)))
    
    chrosome<-as.character(x[1,"bedseqnames"]);
    snppos<-as.numeric(x[1,"snpstart"]);
    transcriptPos<-as.numeric(x[1,"bedstart"]);
    transcriptEndPos<-as.numeric(x[1,"bedend"]);
    
    relativeSnpPos<-snppos-transcriptPos-1;#conver to 0-based coordinate
    
    #cat(str_c("class of bed:",class(x[1,"bedblockStart"]) ) )
    
    #exonStartPoss<-as.numeric(strsplit(x[1,"bedblockStart"],",")[[1]] );  
    #exonEndPoss<-as.numeric(strsplit(as.character(x[1,"bedblockEnds"]),",")[[1]] );
    #cat(exonStartPos,"#",exonEndPos,"\n")
    exonStartPoss<-as.numeric(bedblockStarts[[i]]);
    exonLength<-as.numeric(bedblockSizes[[i]]);
    exonEndPoss<-exonStartPoss+exonLength-1;
    
    
    count<-as.numeric(x[1,"bedblockCount"])
    #cat(str_c("count:",count))
    strand<-as.character(x[1,"bedstrand"]);
    
    exonIndex=-1;
    minToExonStart<-min(abs(relativeSnpPos-exonStartPoss) )
    minToExonEnd<-min(abs(relativeSnpPos-exonEndPoss) )
    
    
    if(minToExonStart<minToExonEnd){
      exonIndex=which.min(abs(relativeSnpPos-exonStartPoss));
    }else{
      exonIndex=which.min(abs(relativeSnpPos-exonEndPoss));
    }
    
    exonBegPos<-exonStartPoss[exonIndex]+transcriptPos;
    exonEndPos<-exonEndPoss[exonIndex]+transcriptPos;
    
    #if in the exon
    if( (relativeSnpPos<=exonEndPoss[exonIndex])&&(relativeSnpPos>=exonStartPoss[exonIndex]) ) {
      distance=0;
      targetExonsAndSNPs<-rbind(targetExonsAndSNPs,
                                c(chrosome,snppos,exonBegPos,exonEndPos,distance,strand) );
      
      next;
    }
    
    
    #if near the exon
    if((minToExonStart<=threshold)||(minToExonEnd<=threshold)){
      #cat(str_c("current transcript is not near the splicing site! 
      #distanceToExonStart:",minToExonStart,"distanceToExonsEnd:",minToExonEnd,"\n"  )  )
      
      distance<-min(minToExonStart,minToExonEnd)
      targetExonsAndSNPs<-rbind(targetExonsAndSNPs,
                                c(chrosome,snppos,exonBegPos,exonEndPos,distance,strand) )  
      
      next;
    }
    
    #targetExons<-c(targetExons,str_c(chrosome,":",exonBegPos,"-",exonEndPos));
    
  }
  
  #write.csv(targetExonsAndSNPs,file="nearest exon with snps.csv",quote=FALSE,row.names=FALSE);
  
  #distance is the distance to the splicing site
  colnames(targetExonsAndSNPs)<-c("chrosome","snppos","exonBegPos","exonEndPos","distance","strand");
  #targetExonsAndSNPs<-targetExonsAndSNPs[order( as.numeric(targetExonsAndSNPs[,"distance"]) ,decreasing=FALSE),]
  
  #only keep one snp for transcripts
  duplicatedLabel<-duplicated(str_c(targetExonsAndSNPs[,"chrosome"],targetExonsAndSNPs[,"snppos"]) );
  targetExonsAndSNPs<-targetExonsAndSNPs[!duplicatedLabel,,drop=FALSE];
  
  #for xinjun's input
  #targetExons<-str_c(targetExonsAndSNPs[,"chrosome"],":",
  #targetExonsAndSNPs[,"exonBegPos"],"-",targetExonsAndSNPs[,"exonEndPos"]);
  #targetExons<-unique(targetExons);
  #cat(paste0("number of SNPs in HGMD target region: ",
  #           nrow(unique(targetExonsAndSNPs[,c("chrosome","snppos")]) ) ,"\n") );
  
  #cat(paste0("number of Exons in HGMD target region: ",
  #           nrow(unique(targetExonsAndSNPs[,c("chrosome","exonBegPos","exonEndPos")]) ) ,"\n") );
  
  write.csv(targetExonsAndSNPs,file="test.1.csv");
  targetExons<-data.frame(chrosome=targetExonsAndSNPs[,"chrosome"],exonBegPos=targetExonsAndSNPs[,"exonBegPos"],
  exonEndPos=targetExonsAndSNPs[,"exonEndPos"],strand=targetExonsAndSNPs[,"strand"],stringsAsFactors=FALSE);
  
  return(targetExons);
  
})

setGeneric("getJunctionExons",function(object,snp,threshold){ })
setMethod("getJunctionExons",
          signature(object="BED",snp="data.frame",threshold="numeric"),
          function(object,snp,threshold){
            #snp<-read.table(snpFileName,header=TRUE,as.is=TRUE);
            chr<-ifelse(!str_detect(snp[,1],"^chr"),
                        str_c("chr",snp[,1]),
                        snp[,1]);
            
            threshold<-threshold+1;
            
            pos<-snp[,2];
            strand<-snp[,3];
            
            #cat(chr)
            #cat(pos)
            # convert snps and transcripts to GenomicRanges
            vcf<-GRanges(chr, IRanges(pos, pos),strand);
            
            bed<-convertToGenomicRange(object);
            cat(mcols(bed)$strand)
            #find the overlap between the transcirpts and snps
            vcfhits<-findOverlaps(vcf,bed);
            wrongAnnotationSNPs<-snp[-unique(queryHits(vcfhits))];
            if(!is.null(wrongAnnotationSNPs)){
              cat("!!can't map on bed transcripts:\n");
              write.csv(wrongAnnotationSNPs);
            }
            #get hited snp information
            vcfFrame<-as(vcf[queryHits(vcfhits)],"data.frame");
            #get hited transcript information
            bedFrame<-as(bed[subjectHits(vcfhits)],"data.frame");
            colnames(vcfFrame)<-str_c("snp",colnames(vcfFrame));
            colnames(bedFrame)<-str_c("bed",colnames(bedFrame));
            #
            vcfbed<-cbind(vcfFrame,bedFrame);
            #cat(str_c("the first line in VCFBED:",vcfbed[1,]) )
            
            #write.csv(vcfbed)
            bedblockStarts<-strsplit(as.character(vcfbed[,"bedblockStarts"]),",");
            bedblockSizes<-strsplit(as.character(vcfbed[,"bedblockSizes"]),",");
            #bedblockEnds<-bedblockStarts+as.numeric(strsplit(as.character(vcfbed[,"bedblockSizes"]),","))-1;
            
            #cat(colnames(vcfbed)) 
            targetExons<-c();
            targetExonsAndSNPs<-matrix(ncol=6,nrow=0);
            
            #result<-apply(vcfbed,1,function(x,desc){
            for(i in 1:nrow(vcfbed)){
              x=vcfbed[i,]
              
              if(is.na(x[1,1]) )
                next;
              #cat(str_c("class of vcfbed line:",class(x)))
              
              chrosome=as.character(x[1,"bedseqnames"]);
              snppos<-as.numeric(x[1,"snpstart"]);
              transcriptPos<-as.numeric(x[1,"bedstart"]);
              transcriptEndPos<-as.numeric(x[1,"bedend"]);
              
              relativeSnpPos<-snppos-transcriptPos-1;#conver to 0-based coordinate
              
              #cat(str_c("class of bed:",class(x[1,"bedblockStart"]) ) )
              
              #exonStartPoss<-as.numeric(strsplit(x[1,"bedblockStart"],",")[[1]] );  
              #exonEndPoss<-as.numeric(strsplit(as.character(x[1,"bedblockEnds"]),",")[[1]] );
              #cat(exonStartPos,"#",exonEndPos,"\n")
              exonStartPoss<-as.numeric(bedblockStarts[[i]]);
              exonLength<-as.numeric(bedblockSizes[[i]]);
              exonEndPoss<-exonStartPoss+exonLength-1;          
              
              count<-as.numeric(x[1,"bedblockCount"])
              #cat(str_c("count:",count))
              strand<-as.character(x[1,"bedstrand"]);
              
              exonIndex=-1;
              #minToExonStart<-min(abs(relativeSnpPos-exonStartPoss) )
              #minToExonEnd<-min(abs(relativeSnpPos-exonEndPoss) )
              for(j in 1:count){
                if(j==1)
                  next;
                if(j==count)
                  next;
                
                exonBegPos<-exonStartPoss[j]+transcriptPos;
                exonEndPos<-exonEndPoss[j]+transcriptPos;
                
                if( (exonStartPoss[j]-relativeSnpPos<threshold)&&(exonStartPoss[j]-relativeSnpPos>0)&&(j!=1)  ){
                  distance<-exonStartPoss[j]-relativeSnpPos+1;
                  
                  targetExonsAndSNPs<-rbind(targetExonsAndSNPs,c(chrosome,snppos,exonBegPos,exonEndPos,distance,strand) );
                }
                
                if( (relativeSnpPos-exonEndPoss[j]<threshold)&&(relativeSnpPos-exonEndPoss[j]>0)&&(j!=count)  ){
                  distance<-relativeSnpPos-exonStartPoss[j]+1;
                  targetExonsAndSNPs<-rbind(targetExonsAndSNPs,c(chrosome,snppos,exonBegPos,exonEndPos,distance,strand) );
                }  
                
              }
      
            }
            
            colnames(targetExonsAndSNPs)<-c("chrosome","snppos","exonBegPos","exonEndPos","distance","strand");
            #targetExonsAndSNPs<-targetExonsAndSNPs[order( as.numeric(targetExonsAndSNPs[,"distance"]) ,decreasing=FALSE),]
            
            #only keep one snp for transcripts
            duplicatedLabel<-duplicated(str_c(targetExonsAndSNPs[,"chrosome"],targetExonsAndSNPs[,"snppos"]) );
            targetExonsAndSNPs<-targetExonsAndSNPs[!duplicatedLabel,,drop=FALSE];
            
            #for xinjun's input
            #targetExons<-str_c(targetExonsAndSNPs[,"chrosome"],":",targetExonsAndSNPs[,"exonBegPos"],"-",targetExonsAndSNPs[,"exonEndPos"]);
            #targetExons<-unique(targetExons)
            write.csv(targetExonsAndSNPs,file="test.1.csv")
            targetExons<-data.frame(chrosome=targetExonsAndSNPs[,"chrosome"],exonBegPos=targetExonsAndSNPs[,"exonBegPos"],
                                    exonEndPos=targetExonsAndSNPs[,"exonEndPos"],strand=targetExonsAndSNPs[,"strand"],stringsAsFactors=FALSE)
            
            return(targetExons);
            
})


###problem here 
setGeneric("getExonsCenterPosition",function(exonRegions){})
setMethod("getExonsCenterPosition",signature(exonRegions="character"),function(exonRegions){
  cat("the method has problem, please don't use!\n")
  anno<-strsplit(exonRegions,":|-");
  
  chrs<-sapply(anno,"[",1);
  begs<-sapply(anno,"[",2);
  ends<-sapply(anno,"[",3);
  
  center<-(begs+ends)/2
  
  return(cbind(chrs,center));
})

###problem here
setGeneric("getNearestExonCenterPosition",function(object,snp,threshold){})
setMethod("getNearestExonCenterPosition",signature(object="BED",snp="data.frame",threshold="numeric"),
          function(object,snp,threshold){
  cat("the method has problem, please don't use!\n")
  exonRegions<-getNearestExons(object,snp,threshold);
  center<-round( (exonRegions[,"exonBegPos"]+exonRegions[,"exonEndPos"])/2 );
  
  exonRegions<-cbind(exonRegions,center);
  
  return(exonRegions);
  #return( str_c(chrs,":",center) );
  
})

setGeneric("getTranscriptIdExonNumber",function(object,snp){})
setMethod("getTranscriptIdExonNumber",,function(object,snp){
  
  chr<-ifelse(!str_detect(snp[,1],"^chr"),
              str_c("chr",snp[,1]),
              snp[,1]);
  
  pos<-snp[,2];
  # convert snps and transcripts to GenomicRanges
  vcf<-GRanges(chr, IRanges(pos, pos));
  
  bed<-convertToGenomicRange(object);
  cat(mcols(bed)$strand)
  #find the overlap between the transcirpts and snps
  vcfhits<-findOverlaps(vcf,bed);
  wrongAnnotationSNPs<-snp[-unique(queryHits(vcfhits))];
  if(!is.null(wrongAnnotationSNPs)){
    cat("!!can't map on bed transcripts:\n");
    write.csv(wrongAnnotationSNPs);
  }
  #get hited snp information
  vcfFrame<-as(vcf[queryHits(vcfhits)],"data.frame");
  #get hited transcript information
  bedFrame<-as(bed[subjectHits(vcfhits)],"data.frame");
  colnames(vcfFrame)<-str_c("snp",colnames(vcfFrame));
  colnames(bedFrame)<-str_c("bed",colnames(bedFrame));
  #
  vcfbed<-cbind(vcfFrame,bedFrame);
  bedblockStarts<-strsplit(as.character(vcfbed[,"bedblockStarts"]),",");
  bedblockSizes<-strsplit(as.character(vcfbed[,"bedblockSizes"]),",");

  transcriptIdExonNumber<-c();
  for(i in 1:nrow(vcfbed) ){
    cbedblockStarts<-vcfbed[i,"bedstart"]+as.numeric(bedblockStarts[[i]]);
    cbedblockEnds<-cbedblockStarts+as.numeric(bedblockSizes[[i]]);
    
    exonIndex<-1;
    for(j in 1:length(cbedblockStarts)){
      if( (vcfbed[i,"snpstart"]>cbedblockStarts[j] )&&vcfbed[i,"snpstart"]<cbedblockStarts[j] )
        exonIndex<-j
    }
    if(vcfbed[i,"bedstrand"]=="-"){
      exonIndex<-as.numeric(vcfbed[i,"bedblockCount"])-j+1
    }
    
    transcriptIdExonNumber<-c(transcriptIdExonNumber,paste(vcfbed[i,"bedname"],":",exonIndex,sep="")  )
    
  }
  
  transcriptIdExonNumber<-unique(transcriptIdExonNumber);
  return(transcriptIdExonNumber);
})

