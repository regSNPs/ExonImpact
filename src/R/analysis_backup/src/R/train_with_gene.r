library(readr);
library(stringr);

set.seed(1010);

all_train_exon<-as.data.frame(rbind(hgmd,neutral) ) ;

label<-c(rep("HGMD",nrow(hgmd) ),rep("NEUTRAL",nrow(neutral)) );
all_train_exon_label<-cbind(all_train_exon,label);

gene_id_mapping<-as.data.frame(read_tsv("data/HGNC/protein-coding_gene_symbol_mapping.tsv",
                                        col_names = TRUE) );
gene_family<-as.data.frame(read_tsv("data/HGNC/gene_family.tsv",col_names = TRUE) );
gene_family[,"HGNC ID"]<-str_c("HGNC:",gene_family[,"HGNC ID"] );


all_train_exon_label_id_mapping<-inner_join(all_train_exon_label,
                                            gene_id_mapping,by=c("gene_id"="ensembl_gene_id") );

all_train_exon_label_id_mapping_family<-inner_join(all_train_exon_label_id_mapping,
                                                   gene_family,by=c("hgnc_id"="HGNC ID"));

###keep each family a single gene, the gene which contain the most exons.
nonhomologene_train_set_hgmd<-ddply(subset(all_train_exon_label_id_mapping_family,label=="HGMD"),
                                    .(`Gene family ID`),function(x){
                                      
  gene_exon_count<-as.data.frame(table(x[,"gene_id"]) );
  gene_id_frq_highest<-gene_exon_count[which.max(gene_exon_count[,"Freq"]),"Var1"];
  
  y<-x[x[,"gene_id"]==gene_id_frq_highest,];
  return(y[,feature_names]);
});

nonhomologene_train_set_neutral<-
  ddply(subset(all_train_exon_label_id_mapping_family,label=="NEUTRAL"),
                                       .(`Gene family ID`),function(x){
  gene_exon_count<-as.data.frame(table(x[,"gene_id"]) );
  gene_id_frq_highest<-gene_exon_count[which.max(gene_exon_count[,"Freq"]),"Var1"];
  
  y<-x[x[,"gene_id"]==gene_id_frq_highest,];
  return(y[,feature_names]);
});

flog.info(paste("number of nonhomologene for HGMD is",nrow(nonhomologene_train_set_hgmd) ) );

flog.info(paste("number of nonhomologene for neutral is",nrow(nonhomologene_train_set_neutral) ) );


nonhomologene_train_set_hgmd_sample<-sample_n(nonhomologene_train_set_hgmd,
                                              nrow(nonhomologene_train_set_neutral) );

nonhomologene_train_set<-rbind(nonhomologene_train_set_hgmd_sample,
                               nonhomologene_train_set_neutral);

#remove the family id
nonhomologene_train_set<-nonhomologene_train_set[,-1];
##651 exons in HGMD and NEUTRAL respectively.

roc_data_gene_cv<-crossValidateRandomForest(nonhomologene_train_set,10) %>% 
  get_roc_data("10-cross validation","HGMD","NEUTRAL");

p<-ggplot(roc_data_gene_cv,aes(x=fpr,ymin=0,ymax=tpr))+
  geom_ribbon(fill="gray66")+#geom_area(fill="green")+
  xlab("False Positive Rate")+ylab("True Positive Rate")+theme_classic()+
  ggtitle(paste0("10 cross-validation\nRemove homologenes in HGMD and NEUTRAL,
                 AUC=",roc_data_gene_cv[1,"auc"]) )+
  theme(text=element_text(size=7) );

pdf("result/roc_for_homolo_gene.pdf");
print(p);
dev.off();
