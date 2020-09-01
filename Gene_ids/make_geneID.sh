WORK_DIR=/scratch/golrokh/Jobs/200203_silversides/results/_BCF_ISEC
inputFiles=_list2geneID.txt
rm $inputFiles
if [ ! -f $inputFiles ]; then
  for i in $WORK_DIR/*/*"BCF"*".vcf.gz"; do
    echo $i >> $inputFiles;
  done
fi

N_SUBJECT=$(wc -l $inputFiles | cut -f1 -d" ")
N_SUBJECT=$((N_SUBJECT + 0))

out1=$(sbatch --array=1-${N_SUBJECT} --account=$1 gene_id.sh)
JOB_ID1=$(echo $out1 | cut -d" " -f4)
echo $JOB_ID1
