#!/bin/bash
#SBATCH --job-name=ANNOVAR
#SBATCH --account=def-banire
#SBATCH --mem=64G
#SBATCH --array=1-12
#SBATCH --output=/home/nicdemon/projects/def-banire/nicdemon/scripts/%x_%a.out
#SBATCH --error=/home/nicdemon/projects/def-banire/nicdemon/scripts/%x_%a.err
#SBATCH --time=12:00:00

cd $SLURM_SUBMIT_DIR
module load nixpkgs/16.09 annovar/2017Jul16

#Set WD
WORK_DIR=/home/nicdemon/projects/def-banire/nicdemon/results
DB_DIR=/home/nicdemon/projects/def-banire/nicdemon/db/dogdb

#Download/build sourceDB
#annotate_variation.pl -downdb -buildver canFam3 gene dogdb
#annotate_variation.pl --buildver canFam3 --downdb seq dogdb/canFam3_seq
#retrieve_seq_from_fasta.pl dogdb/canFam3_refGene.txt -seqfile dogdb/canFam3_seq -format refGene -outfile dogdb/canFam3_refGeneMrna.fa

#List all vcf.gz in folder to file
if [ ! -f $WORK_DIR/files_filtered_vcf.txt ]; then
  for i in $WORK_DIR/"Filtered"*".vcf.gz"; do
    echo $i >> $WORK_DIR/files_filtered_vcf.txt;
  done
  for i in $WORK_DIR/"SNP"*".vcf.gz"; do
      echo $i >> $WORK_DIR/files_filtered_vcf.txt;
  done
  for i in $WORK_DIR/"BCFtools"*".vcf.gz"; do
      echo $i >> $WORK_DIR/files_filtered_vcf.txt;
  done
fi

#Set file list to object
inputFiles=$WORK_DIR/files_filtered_vcf.txt
#Isolate each input file to job ID
file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $inputFiles)
annovar=$WORK_DIR/"$(basename -s .vcf.gz $file).avinput"
out=$WORK_DIR/"ANNOVAR_$(basename -s .vcf.gz $file)"

#Set reference
if [[ "$(basename -- $file)" == *"bas_mem2.vcf.gz" ]]; then
  ref=/home/nicdemon/projects/def-banire/nicdemon/db/GCA_004886185_Basenji.fasta
elif [[ "$(basename -- $file)" == *"can_mem2.vcf.gz" ]]; then
  ref=/home/nicdemon/projects/def-banire/nicdemon/db/GCA_000002285.2_CanFam3.1_genomic.fasta
fi

#Convert vcf to annovar format
convert2annovar.pl -format vcf4 $file > $annovar

#Perform variant annotation
annotate_variation.pl -out $out -build canFam3 $annovar $DB_DIR

cd $SLURM_SUBMIT_DIR
echo $file $SLURM_TASK_ID $SLURM_ARRAY_TASK_ID >> _listTask_ANNOVAR.txt
