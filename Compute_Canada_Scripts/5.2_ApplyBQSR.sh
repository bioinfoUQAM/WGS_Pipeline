#!/bin/bash
#SBATCH --job-name=ApplyBQSR_array
#SBATCH --account=def-banire
#SBATCH --mem=191000M
#SBATCH --array=1-2
#SBATCH --output=/project/def-banire/Labobioinfo/cermo/200203_silversides/scripts/%x_%j_%a.out
#SBATCH --error=/project/def-banire/Labobioinfo/cermo/200203_silversides/scripts/%x_%j_%a.err
#SBATCH --time=08:00:00

cd $SLURM_SUBMIT_DIR
module load nixpkgs/16.09 gatk/4.1.2.0

#Set WD
WORK_DIR=/home/nicdemon/projects/def-banire/Labobioinfo/cermo/200203_silversides/results/array
#List all bams in folder to file
if [ ! -f $WORK_DIR/files_BQSR_tables.txt ]; then
  for i in $WORK_DIR/*.table; do
    echo $i >> $WORK_DIR/files_BQSR_tables.txt;
  done
fi

#Set file list to object
inputFilesBam=$WORK_DIR/files_marked_bam.txt
inputFilesTable=$WORK_DIR/files_BQSR_tables.txt
#Isolate each input file to job ID
fileBam=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $inputFilesBam)
fileTable=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $inputFilesTable)

out=$WORK_DIR/"BQSR_$(basename -- $fileBam)"

gatk ApplyBQSR -I $fileBam -O $out --bqsr-recal-file $fileTable

cd $SLURM_SUBMIT_DIR
echo $file $SLURM_TASK_ID $SLURM_ARRAY_TASK_ID >> _listTask_ApplyBQSR.txt
