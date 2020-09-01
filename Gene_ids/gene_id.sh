#!/bin/bash
#SBATCH --job-name=GeneID
#SBATCH --account=def-banire
#SBATCH --mem=64G
#SBATCH --output=/scratch/golrokh/Jobs/200203_silversides/results/_logs/%x_%A_%a.out
#SBATCH --error=/scratch/golrokh/Jobs/200203_silversides/results/_logs/%x_%A_%a.err
#SBATCH --time=12:00:00

cd $SLURM_SUBMIT_DIR
#If don't have python3 in conda environment
#module load python/3.8.2
#must install pysam, gtfparse & pyvcf for python3

#Set WD
WORK_DIR=/scratch/golrokh/Jobs/200203_silversides/results/_BCF_ISEC
REFERENCE=/project/def-banire/Labobioinfo/annotations/Canis_lupus/CanFam3.1/GCF_000002285.3_CanFam3.1_genomic_chr.gtf

inputFiles=$WORK_DIR/_list2geneID.txt

file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $inputFiles)
#Must gunzip vcf files to give to python
gunzip $file
file="$(dirname "${file}")"/"$(basename -s .vcf.gz $file).vcf"

out="$(dirname "${file}")"/"GeneID_$(basename -s .vcf.gz $file).tsv"

python3 gene_id.py $file $REFERENCE $out
#Usage : gene_id.py annotated_variants.vcf.gz reference.gtf out.tsv

#Rezip vcf file
gzip $file

#Give back acess
setfacl -R -m u:golrokh:rwx $WORK_DIR/*
setfacl -R -m u:golrokh:rwx /scratch/golrokh/Jobs/200203_silversides/results/_logs/*
