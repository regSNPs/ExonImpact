

abvMap<-list();

  abvMap[["ss"]]<-"Secondary structure";
  abvMap[["disorder"]]<-"Disorder score";
  abvMap[["asa"]]<-"Solvent accessible surface area";

  abvMap[["phylop"]]<-"Average phylop score";
  abvMap[["ptm"]]<-"Normilize number of PTM sites in exon region";
  abvMap[["pfam"]]<-"Coverage percentile of the domains";
  
  abvMap[["ss_1"]]<-"Max probability of amino acids' most probable secondary structure";
  abvMap[["ss_2"]]<-"Min probability of amino acids' most probable secondary structure";
  abvMap[["ss_3"]]<-"Average probability of amino acids' most probable secondary structure";
  abvMap[["ss_4"]]<-"Average probability of amino acids  in beta sheet";
  abvMap[["ss_5"]]<-"Min probability of amino acids in beta sheet";
  abvMap[["ss_6"]]<-"Max probability of amino acids in beta structure";
  abvMap[["ss_7"]]<-"Average probability of amino acids in coil structure";
  abvMap[["ss_8"]]<-"Min probability of amino acids coil structure";
  abvMap[["ss_9"]]<-"Max probability of amino acids in coil structure";
  abvMap[["ss_10"]]<-"Average probability of amino acids in alpha-helix structure";
  abvMap[["ss_11"]]<-"Min probability of amino acids in alpha-helix structure";
  abvMap[["ss_12"]]<-"Max probability of amino acids in alpha-helix structure";
  
  abvMap[["asa_1"]]<-"Average ASA of amino acids";
  abvMap[["asa_2"]]<-"Min ASA of amino acids";
  abvMap[["asa_3"]]<-"Max ASA of amino acids";
  
  abvMap[["disorder_1"]]<-"Min disorder score of amino acids";
  abvMap[["disorder_2"]]<-"Max disorder score of amino acids";
  abvMap[["disorder_3"]]<-"Average disorder socre of disorder region";
  abvMap[["disorder_4"]]<-"Average score of structured region";
  abvMap[["disorder_5"]]<-"Time of switch between disorder region and structured region";
  abvMap[["disorder_6"]]<-"Average disorder region length";
  abvMap[["disorder_7"]]<-"Average disorder segement length";
  abvMap[["disorder_8"]]<-"Max disorder segement length";
  abvMap[["disorder_9"]]<-"Min disorder segement length";
  abvMap[["disorder_10"]]<-"Max structured region length";
  abvMap[["disorder_11"]]<-"Min structured region length";
  abvMap[["disorder_12"]]<-"Average disorder socre"; 

abv<-function(abvs){
  return(abvs);
  
  fullNames<-c();
  for(i in 1:length(abvs)){
    if(is.null(abvMap[[ abvs[i] ]])  ){
      cat(abvs[i])
      
            
    }
    
    fullNames<-c(fullNames,abvMap[[abvs[i] ]])
  }
  
  return(fullNames);
  
}


