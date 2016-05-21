
parse_AAchange<-function(aa_changes){
  #aa_changes<-readLines(file_name);
  aa_changes<-aa_changes[aa_changes!="."];
  aa_changes_split<-str_split(aa_changes,":")
  
  transcript_id<-sapply(aa_changes_split,"[",2);
  exon_id<-str_sub(sapply(aa_changes_split,"[",3) ,5);
  
  transcript_exon_id<-str_c(transcript_id,":",exon_id);
  
  return(transcript_exon_id);
}

