BAM=$1
SAMPLEFILE=`basename $BAM`
SAMPLEFILE=${SAMPLEFILE/.bam}

basedir=/N/dc2/scratch/liulab/limeng/RBP_network/rnaseq;
mkdir $basedir/$SAMPLEFILE/

#samtools view -h $BAM |sed -s 's/\/1\|\/2//' - |samtools view -bS - > $basedir/$SAMPLEFILE/$SAMPLEFILE.bam
samtools view -h $BAM | grep -v ERCC | samtools view -bS - > $basedir/$SAMPLEFILE/$SAMPLEFILE.bam_p

echo $SAMPLEFILE;

samtools sort $basedir/$SAMPLEFILE/$SAMPLEFILE.bam_p $basedir/$SAMPLEFILE/$SAMPLEFILE
samtools index $basedir/$SAMPLEFILE/$SAMPLEFILE.bam 

LEN=`samtools view $basedir/$SAMPLEFILE/*.bam| head -n 1 | awk '{print length($10)}'`

ifpair=`samtools view -f 0x1 $basedir/$SAMPLEFILE/$SAMPLEFILE.bam | head -n 1 | wc -l`

#echo "pair_read_row$ifpair";

if [[ "$ifpair" -eq 1 ]]
then
  pe_utils  --compute-insert-len $basedir/$SAMPLEFILE/$SAMPLEFILE.bam /N/u/liulab/Karst/limeng/data/Homo_sapiens/hg19/exonschr/ensGene.min_1000.const_exons.gff --output-dir $basedir/$SAMPLEFILE/
  #LEN=`samtools view $basedir/$SAMPLEFILE/*.bam|grep -m 1 -P -o "\t\\d+M\t"|sed -s 's/\t\|M//g'`
  echo sequencelength=$LEN;

  INSERT=`less -S $basedir/$SAMPLEFILE/*.insert_len |grep -m 1 -P -o "#mean=\\d+" |sed -s 's/#\|mean\|=//g'`
  DIST=`less -S $basedir/$SAMPLEFILE/*.insert_len |grep -m 1 -P -o "sdev=\\d+" |sed -s 's/sdev\|=//g'`

  miso --run /N/dc2/projects/ngs/liulab_limeng/miso/indexed_SE_events4/ $basedir/$SAMPLEFILE/*.bam --output-dir $basedir/$SAMPLEFILE/miso_output/ --read-len $LEN --paired-end $INSERT $DIST

else
  miso --run /N/dc2/projects/ngs/liulab_limeng/miso/indexed_SE_events4/ $basedir/$SAMPLEFILE/*.bam --output-dir $basedir/$SAMPLEFILE/miso_output/ --read-len $LEN

fi
summarize_miso --summarize-samples $basedir/$SAMPLEFILE/miso_output/ $basedir/$SAMPLEFILE/miso_output/
