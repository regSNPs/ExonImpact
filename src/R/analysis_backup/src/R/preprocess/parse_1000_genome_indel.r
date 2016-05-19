setwd("/Users/mengli/Documents/splicingSNP_new")
source("src/R/preprocess/parse_AAchange.r");

transcript_exon_id_filter<-parse_AAchange("data/1000_genome_indel/aa_change_uniq");
cat(unique(transcript_exon_id_filter),file="data/1000_genome_indel/1000_genome_transcript_exon_id",sep="\n");
