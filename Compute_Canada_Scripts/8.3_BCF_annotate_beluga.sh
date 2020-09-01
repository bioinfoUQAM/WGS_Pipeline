#!/bin/bash
#SBATCH --job-name=BCF_annotate
#SBATCH --account=def-banire
#SBATCH --mem=64G
#SBATCH --array=1-12
#SBATCH --output=/home/nicdemon/projects/def-banire/nicdemon/scripts/%x_%a.out
#SBATCH --error=/home/nicdemon/projects/def-banire/nicdemon/scripts/%x_%a.err
#SBATCH --time=12:00:00

cd $SLURM_SUBMIT_DIR
module load nixpkgs/16.09 intel/2018.3 gatk/4.1.2.0 bcftools/1.10.2

#Set WD
WORK_DIR=/home/nicdemon/projects/def-banire/nicdemon/results

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
out=$WORK_DIR/"BCFannotate_$(basename -- $file)"

#set column headers
columns=CHROM,FROM,-,ID,SCORE,STRAND,SOURCE,TYPE,PHASE,ATTRIBUTES

#Set annotations bed to object
annot=/project/def-banire/Labobioinfo/annotations/Canis_lupus/CanFam3.1/GCF_000002285.3_CanFam3.1_gff.bed
annotgz=/project/def-banire/Labobioinfo/annotations/Canis_lupus/CanFam3.1/GCF_000002285.3_CanFam3.1_gff.bed.gz
#Index bedfile
#tabix -p bed $annotgz

#Set header file to object
header=/home/nicdemon/projects/def-banire/nicdemon/scripts/8.3_header.txt

#Run BCFtools to annotate variants
bcftools annotate -a $annotgz -c $columns -h $header -o $out -O z --threads 48 $file

#Index vcf after creation
gatk IndexFeatureFile -F $out

Error: failed to write to /home/nicdemon/projects/def-banire/nicdemon/results/BCFannotate_SNP_BCFtools_BQSR_marked_G7_can_mem2.vcf.gz
