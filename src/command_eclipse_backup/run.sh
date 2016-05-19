query_file_name=${1};
`~/jdk1.8.0_51/bin/java -cp "Run.jar:lib_jar/*" ccbb.hrbeu.exonimpact.test.Run $query_file_name configuration.txt >  "error_$query_file_name" 2>&1`;

export R_LIBS=/home/limeng/R/x86_64-redhat-linux-gnu-library/3.1;
`/usr/local/bin/Rscript R/predict.r usr_input/$query_file_name > error2_$query_file_name 2>&1`

