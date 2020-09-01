#!/bin/bash
#SBATCH --job-name=AnalyzeBQSR_array
#SBATCH --account=def-banire
#SBATCH --mem=16G
#SBATCH --array=1-2
#SBATCH --output=/project/def-banire/Labobioinfo/cermo/200203_silversides/scripts/%x_%j_%a.out
#SBATCH --error=/project/def-banire/Labobioinfo/cermo/200203_silversides/scripts/%x_%j_%a.err
#SBATCH --time=08:00:00

cd $SLURM_SUBMIT_DIR
module load nixpkgs/16.09 gatk/4.1.2.0 mugqic/R_Bioconductor/3.6.0_3.9

#Set WD
WORK_DIR=/home/nicdemon/projects/def-banire/Labobioinfo/cermo/200203_silversides/results/array
#List all bams in folder to file
if [ ! -f $WORK_DIR/files_after_tables.txt ]; then
  for i in $WORK_DIR/"After_"*".table"; do
    echo $i >> $WORK_DIR/files_after_tables.txt;
  done
fi

#Set file list to object
beforeFilesTable=$WORK_DIR/files_BQSR_tables.txt
afterFilesTables=$WORK_DIR/files_after_tables.txt
#Isolate each input file to job ID
fileBefore=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $beforeFilesTable)
fileAfter=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $afterFilesTable)

out=$WORK_DIR/"AnalyzeBQSR_$(basename -s .table $fileBefore).pdf"
out=$WORK_DIR/AnalyzeBQSR_B7.pdf
out=$WORK_DIR/AnalyzeBQSR_SRR.pdf

gatk AnalyzeCovariates --java-options '-DGATK_STACKTRACE_ON_USER_EXCEPTION=true' -before $fileBefore -after $fileAfter -plots $out

cd $SLURM_SUBMIT_DIR
echo $file $SLURM_TASK_ID $SLURM_ARRAY_TASK_ID >> _listTask_AnalyzeBQSR.txt
