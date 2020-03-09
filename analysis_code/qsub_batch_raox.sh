BAM=$1
SAMPLE=`basename $BAM`
SCRIPT="sh /N/u/liulab/Karst/limeng/RBP_network/batch_miso_raox.sh $BAM"
echo $SCRIPT > $SAMPLE.job
qsub -l nodes=1:ppn=4,walltime=12:00:00,mem=12gb -M li487@iupui.edu -d /N/dc2/scratch/liulab/limeng/RBP_network/ -m ae -N $SAMPLE $SAMPLE.job
#rm $SAMPLE.job
