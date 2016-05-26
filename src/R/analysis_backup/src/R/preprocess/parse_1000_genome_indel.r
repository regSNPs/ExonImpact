setwd("/Users/mengli/Documents/splicingSNP_new")
source("src/R/preprocess/parse_AAchange.r");

aa_change<-readLines("data/1000_genome_indel/aa_change_uniq");
transcript_exon_id_filter<-parse_AAchange(aa_change);
cat(unique(transcript_exon_id_filter),file="1000_genome_transcript_exon_id",sep="\t" );
