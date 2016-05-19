setwd("/Users/mengli/Documents/splicingSNP_new")
source("src/R/preprocess/parse_AAchange.r");


###clinvar indel parse
transcript_exon_id_filter<-parse_AAchange("data/clinvar/benign_indel/benign_indel_aachange");
cat(unique(transcript_exon_id_filter),file="data/clinvar/benign_indel/benign_indel_transcript_exon_id",sep="\n");

transcript_exon_id_filter<-parse_AAchange("data/clinvar/pathogenic_indel/pathogenic_indel_aachange");
cat(unique(transcript_exon_id_filter),file="data/clinvar/pathogenic_indel/pathogenic_indel_transcript_exon_id",sep="\n");

