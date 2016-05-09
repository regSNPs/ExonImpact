setwd("/Users/mengli/Documents/splicingSNP/exon_impact_new/");
library(seqinr);

fasta_seqs<-read.fasta("refgene_hg19.seq");

ref_link<-read.table("reflink_map.tsv",fill=TRUE,header=TRUE,as.is=TRUE);

protein_names<-sapply(strsplit(attr(fasta_seqs,"name"),"\\." ),"[",1 );

for(i in 1:length(fasta_seqs)){
  
  protein_name<-protein_names[i];
  mrna_acc<-ref_link[ref_link[,"protAcc"]==protein_name,"mrnaAcc"];
  seq<-paste0(as.character(fasta_seqs[i][[1]]),collapse = "" );
  seq_upper<-toupper(seq);
  
  write.fasta( seq, mrna_acc,file.out=paste0("sequences/",mrna_acc) );
  
}

