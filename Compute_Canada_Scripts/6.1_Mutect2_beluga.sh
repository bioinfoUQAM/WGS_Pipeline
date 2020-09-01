#!/bin/bash
#SBATCH --job-name=Mutect2
#SBATCH --account=def-banire
#SBATCH --mem=191000M
#SBATCH --array=1-4
#SBATCH --output=/home/nicdemon/projects/def-banire/nicdemon/scripts/%x_%a.out
#SBATCH --error=/home/nicdemon/projects/def-banire/nicdemon/scripts/%x_%a.err
#SBATCH --time=72:00:00

cd $SLURM_SUBMIT_DIR
module load nixpkgs/16.09 gatk/4.1.2.0

#Set WD
WORK_DIR=/home/nicdemon/projects/def-banire/nicdemon/results

#List all bams in folder to file
#if [ ! -f $WORK_DIR/files_varCall_bam.txt ]; then
#  for i in $WORK_DIR/"BQSR_"*".bam"; do
#    echo $i >> $WORK_DIR/files_varCall_bam.txt;
#  done
#  for i in $WORK_DIR/"marked_"*"_bas_mem2.bam"; do
#    echo $i >> $WORK_DIR/files_varCall_bam.txt;
#  done
#fi

#Set file list to object
inputFiles=$WORK_DIR/files_varCall_bam.txt
#Isolate each input file to job ID
file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $inputFiles)
out=$WORK_DIR/"mutect_$(basename -s .bam $file)vcf.gz"

if [[ "$(basename -- $file)" == *"bas_mem2.bam" ]]; then
  ref=/home/nicdemon/projects/def-banire/nicdemon/db/GCA_004886185_Basenji.fasta
elif [[ "$(basename -- $file)" == *"can_mem2.bam" ]]; then
  ref=/home/nicdemon/projects/def-banire/nicdemon/db/GCA_000002285.2_CanFam3.1_genomic.fasta
fi

#Generate gvcf files + index
gatk Mutect2 -R $ref -I $file -O $out

cd $SLURM_SUBMIT_DIR
echo $file $SLURM_TASK_ID $SLURM_ARRAY_TASK_ID >> _listTask_Mutect2.txt
