#!/bin/bash
#SBATCH --job-name=MarkDuplicates_array
#SBATCH --account=def-banire
#SBATCH --mem=191000M
#SBATCH --array=1-4
#SBATCH --output=/project/def-banire/Labobioinfo/cermo/200203_silversides/scripts/%x_%j_%a.out
#SBATCH --error=/project/def-banire/Labobioinfo/cermo/200203_silversides/scripts/%x_%j_%a.err
#SBATCH --time=08:00:00

cd $SLURM_SUBMIT_DIR
module load nixpkgs/16.09 picard/2.20.6

#Preset
#Set WD
DATA_DIR=/home/nicdemon/projects/def-banire/Labobioinfo/cermo/200203_silversides/data
WORK_DIR=/home/nicdemon/projects/def-banire/Labobioinfo/cermo/200203_silversides/results/array
#List all bams in folder to file
if [ ! -f $DATA_DIR/files_bam.txt ]; then
  for i in $DATA_DIR/*.bam; do
    echo $i >> $WORK_DIR/files_bam.txt;
  done
fi

#Set file list to object
inputFiles=$WORK_DIR/files_bam.txt
#Isolate each input file to job ID
file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $inputFiles)

out=$WORK_DIR/"marked_$(basename -- $file)"
metrics=$WORK_DIR/"marked_metrics_$(basename -- $file)"

java -jar $EBROOTPICARD/picard.jar MarkDuplicates INPUT=$file OUTPUT=$out METRICS_FILE=$metrics MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000
#  REMOVE_SEQUENCING_DUPLICATES=true
#  REMOVE_DUPLICATES=true

cd $SLURM_SUBMIT_DIR
echo $file $SLURM_TASK_ID $SLURM_ARRAY_TASK_ID >> _listTask_markDups.txt
