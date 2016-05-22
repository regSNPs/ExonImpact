# ExonImpact

GPLv3 License

After download the software from this site, the first step is building the required database. 
However, we strongly recommend the users download the database from our website, rather than build it by themsele. One reason is that SPINE-X and SPINE-D is very very time consuming (We took a month to run it on IU supercomputer). 

After this, users should open the configuration.txt file to set the path to the download database, if everything goes well, then you have installed our tools. However, although the features extraction part is code in java, but the FIS calculation part is code by R with less than 100 lines code (search 'predict.r' in the source folder). If you are familiar with R, this will be a small cake for you. 

So in all, the install procedure include:

# Install
1. download the database from:  
wget https://watson.compbio.iupui.edu/ExonImpact/db/ensembl.db  
wget https://watson.compbio.iupui.edu/ExonImpact/db/phylop/*  
wget https://watson.compbio.iupui.edu/ExonImpact/db/ens_extern_hg19.bed  
wget https://watson.compbio.iupui.edu/ExonImpact/db/chrom/*   

2. set the path in 'configuration.txt'.  
Set the path to the download database in the configuration.txt file. 
Users need to donwload some jar libraries which will be used by the tool.

commons-beanutils-1.9.2.jar
commons-configuration2-2.0.jar
commons-io-2.5.jar
commons-lang3-3.4.jar
igv.jar
log4j-1.2.17.jar
picard-1.119.jar
sqlite-jdbc-3.8.11.2.jar

3. check the 'predict.r' file. 
It is in the source folder. 

If you found this tool userful, please star it. We welcome anyone to improve our tool. 

Contact information yunliu@iupui.edu or li487@iupui.edu.

#Some explanation

If the input is Exon_id format, the first and last exon will be removed which defined in Bed_region_extractor:85.

Three inputs format are accept, Inlucde:
1. bed format
2. Miso format
3. Exon Id format

The output is in the usr_input directory, although these can be changed very easily when you set up the tool. 
