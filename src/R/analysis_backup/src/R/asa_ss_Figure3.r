library(ggplot2);
library(reshape2);
library(R.devices);

setwd("/Users/mengli/Documents/splicingSNP_new/");
source("src/R/multiplot.r");
source("src/R/platte.r");

plotcoilasa<-function(){
  
  #load the spine-X and spine-D data
  spine_d_data<-read.table("data/asa_random_coil/ENST00000315285.spd",
                           header=FALSE);
  spine_x_data<-read.table("data/asa_random_coil/ENST00000315285.spXout",
                           header=TRUE,comment.char = '$');
  
  #extract the plot region
  asa_region=spine_x_data[127:390,"ASA"];
  asa_region=asa_region/max(asa_region);
  
  #the target region
  #227-328
  domain_start<-227;
  domain_end<-328;
  
  #127-390
  plot_data<-data.frame(position=127:390,
                        p_e=spine_x_data[127:390,"P_E"]+00,
                        p_c=spine_x_data[127:390,"P_C"]+2,
                        p_h=spine_x_data[127:390,"P_H"]+4,
                        disorder=spine_d_data[127:390,3]+6,
                        asa=asa_region+8
  );
  plot_data_melt<-melt(plot_data,id.vars = "position");
  
  #plot(127:390,spine_d_data[127:390,3]);
  p2<-ggplot(plot_data_melt)+geom_line(aes(x=position,y=value,color=variable) )+
    geom_segment(aes(x=domain_start,xend=domain_end,y=10.,yend=10),size=6,color="green")+

    geom_text(aes(x=290,y=10),size=2 ,label="microtubules interaction region")+
    geom_segment(aes(x=227,xend=227,y=0,yend=9.5),size=0.5,color="black",linetype=2)+
    geom_segment(aes(x=290,xend=290,y=0,yend=9.5),size=0.5,color="black",linetype=2)+
    
    theme_minimal()+
    theme(axis.ticks = element_blank(),
                          axis.text.y = element_blank(),
                          text=element_text(size=7)
                          )+
     scale_colour_discrete(name  ="Feature",
                      breaks=c("p_e", "p_c","p_h","disorder","asa"),
       labels=c("beta sheet", "random coil","alpha helix","disoder","asa") )+xlab("amino acid index")+
    geom_text(x=125,y=10, fontface = "bold",label="b  ",size = 3,family="Helvetica")+
    #geom_text(x=280,y=12,size = 3,colour="#333333",label="Strucutre features of NM_014946",family="Helvetica");
    ggtitle("Structure features of NM_014946");
  
  
  
  p1<-ggplot(all_data_filter)+geom_point(aes(x=ss_8,y=asa_1,color=label,shape=label),size=1 )+theme_classic()+
    xlab("ss_8 (min probability of the amino acid in coil)")+
    ylab("asa_1 (average ASA in translated amino acid sequence)")+
    geom_segment(aes(x=min(ss_8),xend=max(ss_8),y=median(asa_1),
                     yend=median(asa_1) ),color="black",linetype=2,size=0.5 )+
    geom_text(aes(x=max(ss_8)-(max(ss_8)-min(ss_8))/6,y=median(asa_1)-(max(asa_1)-min(asa_1))/50 ),
              label="Median of Average ASA" ,size=2)+
    
    scale_fill_discrete(name=" ",palette=platt_color,labels=c("HGMD","NEUTRAL"))+#+scale_color_identity()+
    
    annotate("rect", xmin = 0.72, xmax = 0.9, ymin = 24, ymax = 46,
             alpha = .1)+
    geom_text(aes(x=0,y=69), fontface = "bold",label="a ",size = 3,family="Helvetica")+
    ggtitle("Scatter plot of asa and coil")+
    theme( text=element_text(size=7) );
  
    multiplot(p1,p2,cols=2);
  
}


pdf("result/Figure-3 (random coil&asa).pdf",width=8,height=3.5);
plotcoilasa();
dev.off();

setEPS();
postscript("result/eps/Figure-3 (random coil&asa).eps",width=8,height=3.5 );
plotcoilasa();
dev.off();



