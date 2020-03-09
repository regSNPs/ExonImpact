setwd("/Users/mengli/Documents/splicingSNP_new")
source("src/R/preprocess/parse_AAchange.r");


###clinvar indel parse
aa_change_benign<-readLines("data/clinvar/benign_indel/benign_indel_aachange");
transcript_exon_id_filter<-parse_AAchange(aa_change_benign);
cat(unique(transcript_exon_id_filter),file="data/clinvar/benign_indel/benign_indel_transcript_exon_id",sep="\n");

aa_change_pathogenic<-readLines("data/clinvar/pathogenic_indel/pathogenic_indel_aachange");
transcript_exon_id_filter<-parse_AAchange(aa_change_pathogenic);
cat(unique(transcript_exon_id_filter),file="data/clinvar/pathogenic_indel/pathogenic_indel_transcript_exon_id",sep="\n");

