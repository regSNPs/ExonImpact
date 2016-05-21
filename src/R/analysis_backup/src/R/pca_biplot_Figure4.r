library("factoextra");


setwd("/Users/mengli/Documents/splicingSNP_new/");

plotFigure4<-function(taxes){
  
  a<-princomp(all_data_filter[,-1],cor=TRUE);
  
  p<-fviz_pca_biplot(a,axes=taxes,data=all_data_filter[,-1],label ="none",habillage=all_data_filter[,1],
                  col.var = c(rep("blue",1),rep("red",12),
                              rep("darkgoldenrod2",3),rep("black",12),
                              rep("green",2),rep("blueviolet",1)  ,rep("yellow",1))
                  ,labelsize=0.0001,pointsize = 1)+theme_classic()+ theme(text = element_text(size=7) )#+theme_classic();
  p<-p+ggtitle("PCA biplot");
  p<-p+  annotate("rect", xmin = 4, xmax = 7.5, ymin = -2.0, ymax= 0,
                    alpha = .2);
  #p<-p+scale_colour_brewer(name="");
  #p<-p+scale_shape(name="");
  p<-p+scale_color_discrete(name="");
  p<-p+scale_shape_discrete(name="");
  p<-p+geom_point(aes(x=seq(0.0001,0.0001,by=0.0001),y=seq(0.0001,0.0001,by=0.0001),
                      size=c("phylop","secondary structure","ASA","disorder","pfam","ptm","protein length") ),
                  colour="black")
  p<-p+guides(size=guide_legend("Features", 
                                override.aes=list(shape=95, size = 7,
                                colour=c("darkgoldenrod2","black","green","blue","yellow","blueviolet","red") )));
  
  print(p);
  return(p);
  
}


pdf("result/Figure-4 (pca biplot).pdf",width=8,height=5);
p12<-plotFigure4(c(1,2) );
dev.off();


setEPS();
postscript("result/eps/Figure-4 (pca biplot).eps",width=8,height=5 );
p12<-plotFigure4(c(1,2) );
dev.off();


