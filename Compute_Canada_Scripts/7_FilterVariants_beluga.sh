#!/bin/bash
#SBATCH --job-name=FilterVCF
#SBATCH --account=def-banire
#SBATCH --mem=191000M
#SBATCH --array=1-4
#SBATCH --output=/home/nicdemon/projects/def-banire/nicdemon/scripts/%x_%a.out
#SBATCH --error=/home/nicdemon/projects/def-banire/nicdemon/scripts/%x_%a.err
#SBATCH --time=24:00:00

cd $SLURM_SUBMIT_DIR
module load nixpkgs/16.09 gatk/4.1.2.0

#Set WD
WORK_DIR=/home/nicdemon/projects/def-banire/nicdemon/results

#List all vcf.gz in folder to file
#if [ ! -f $WORK_DIR/files_filter_vcf.txt ]; then
#  for i in $WORK_DIR/"mutect"*".vcf.gz"; do
#    echo $i >> $WORK_DIR/files_filter_vcf.txt;
#  done
#fi

#Set file list to object
inputFiles=$WORK_DIR/files_filter_vcf.txt
#Isolate each input file to job ID
file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $inputFiles)
out=$WORK_DIR/"Filtered_$(basename -- $file)"

#Set reference
if [[ "$(basename -- $file)" == *"bas_mem2.vcf.gz" ]]; then
  ref=/home/nicdemon/projects/def-banire/nicdemon/db/GCA_004886185_Basenji.fasta
elif [[ "$(basename -- $file)" == *"can_mem2.vcf.gz" ]]; then
  ref=/home/nicdemon/projects/def-banire/nicdemon/db/GCA_000002285.2_CanFam3.1_genomic.fasta
fi

gatk FilterMutectCalls -R $ref -V $file -O $out
gatk IndexFeatureFile -F $out

cd $SLURM_SUBMIT_DIR
echo $file $SLURM_TASK_ID $SLURM_ARRAY_TASK_ID >> _listTask_FilterVCF.txt
