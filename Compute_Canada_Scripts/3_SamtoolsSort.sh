#!/bin/bash
#SBATCH --job-name=SortSam
#SBATCH --account=def-banire
#SBATCH --mem=191000M
#SBATCH --array=1-2
#SBATCH --output=/project/def-banire/Labobioinfo/cermo/200203_silversides/scripts/%x_%j_%a.out
#SBATCH --error=/project/def-banire/Labobioinfo/cermo/200203_silversides/scripts/%x_%j_%a.err
#SBATCH --time=08:00:00

cd $SLURM_SUBMIT_DIR
module load nixpkgs/16.09 intel/2018.3 openmpi/2.1.1 samtools/1.9

#Preset
#Set WD
WORK_DIR=/home/nicdemon/projects/def-banire/Labobioinfo/cermo/200203_silversides/results
#List all bams in folder to file
#echo $WORK_DIR/marked_merge*.bam >> $WORK_DIR/files_marked_bam.txt
if [ ! -f $WORK_DIR/files_marked_bam.txt ]; then
  for i in $WORK_DIR/marked_merge*.bam; do
    echo $i >> $WORK_DIR/files_marked_bam.txt;
  done
fi

#Set file list to object
inputFiles=$WORK_DIR/files_marked_bam.txt
#Isolate each input file to job ID
file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $inputFiles)

out="sorted_$(basename -- $file)"
outfile=$WORK_DIR"/"$out

samtools sort -l 1 -o $outfile -O bam $file

cd $SLURM_SUBMIT_DIR
echo $file $SLURM_TASK_ID $SLURM_ARRAY_TASK_ID >> _listTask_sortSam.txt
