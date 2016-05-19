setwd("/Users/mengli/Documents/splicingSNP_new/data/build_db");
library(seqinr);

mwrite.fasta<-function(seq,name){
  seq_len<-nchar(seq);
  file_name<-paste0("sequences/",name);
  
  cat("",file=file_name,append=FALSE);
  
  number_of_line=ceiling(seq_len/50)
  cat(paste0(">",name,"\n"),file=file_name,append=TRUE);
  
  for(i in 1:number_of_line){
    start=(i-1)*50+1;
    end=start+49;
    if(end>seq_len)
      end=seq_len
    cat(paste0(substr(seq,start,end),"\n"),file=file_name,append=TRUE);
  }
  
}

fasta_seqs<-read.fasta("refgene_hg19.seq");

ref_link<-read.table("reflink_map.tsv",fill=TRUE,header=TRUE,as.is=TRUE);

protein_names<-sapply(strsplit(attr(fasta_seqs,"name"),"\\." ),"[",1 );

for(i in 1:length(fasta_seqs)){
  
  protein_name<-protein_names[i];
  mrna_acc<-ref_link[ref_link[,"protAcc"]==protein_name,"mrnaAcc"];
  seq<-paste0(as.character(fasta_seqs[i][[1]]),collapse = "" );
  seq_upper<-toupper(seq);
  mwrite.fasta(seq_upper,mrna_acc);
}
#mwrite.fasta(seq,mrna_acc);
#XEGDLSHIHRLQNLTIDILVYDNHVHVARSLKVGSFLRIYSLHTKLQSMN
