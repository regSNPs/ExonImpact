#library("devtools");
#install_github("kassambara/factoextra");
library("factoextra");


setwd("/Users/mengli/Documents/splicingSNP_new/");

plotFigure4<-function(taxes){
  
  selectNames<-c("Label","phylop","ss_1","ss_2","ss_3",
                             "ss_4","ss_5","ss_6","ss_7","ss_8",
                             "ss_9","ss_10","ss_11","ss_12",
                             "asa_1","asa_2","asa_3",
                             "d_1","d_2","d_3","d_4","d_5","d_6","d_7",
                             "d_8","d_9","d_10","d_11","d_12",
                             "pfam1","pfam2",
                             "ptm","proteinLength"
  );

  a<-princomp(all_data_filter[,-1],cor=TRUE);
  
  p<-fviz_pca_biplot(a,axes=taxes,data=all_data_filter[,-1],label ="var",habillage=all_data_filter[,1],
                  col.var = c(rep("blue",1),rep("red",12),
                              rep("darkgoldenrod2",3),rep("black",12),
                              rep("green",2),rep("blueviolet",1)  ,rep("yellow",1))
                  ,labelsize=0,pointsize = 1)+ theme(text = element_text(size=7) )#+theme_classic();
  p<-p+ggtitle("PCA biplot")
  p<-p+  annotate("rect", xmin = 4, xmax = 7.5, ymin = -2.0, ymax= 0,
                    alpha = .2)
  
  p<-p+geom_point(aes(x=seq(0.0001,0.0001,by=0.0001),y=seq(0.0001,0.0001,by=0.0001),
                      size=c("phylop","secondary structure","ASA","disorder","pfam","ptm","protein length") ),
                  colour="black")
  p<-p+guides(size=guide_legend("Features", 
                                override.aes=list(shape=95, size = 7,
                                colour=c("darkgoldenrod2","black","green","blue","yellow","blueviolet","red") )));
  print(p);
  return(p);
  
}

#setwd(workingDir);

pdf("result/Figure-4 (pca biplot).pdf",width=8,height=5);
p12<-plotFigure4(c(1,2) );
dev.off();


setEPS();
postscript("result/eps/Figure-4 (pca biplot).eps",width=8,height=5 );
p12<-plotFigure4(c(1,2) );
dev.off();


