#!/bin/bash
#SBATCH --job-name=BQSR_after_array
#SBATCH --account=def-banire
#SBATCH --mem=16G
#SBATCH --array=1-2
#SBATCH --output=/project/def-banire/Labobioinfo/cermo/200203_silversides/scripts/%x_%j_%a.out
#SBATCH --error=/project/def-banire/Labobioinfo/cermo/200203_silversides/scripts/%x_%j_%a.err
#SBATCH --time=08:00:00

cd $SLURM_SUBMIT_DIR
module load nixpkgs/16.09 gatk/4.1.2.0

#Create dictionnary & .fai for reference
#module load nixpkgs/16.09 intel/2018.3 openmpi/2.1.1 samtools/1.9 picard/2.20.6
#java -jar $EBROOTPICARD/picard.jar CreateSequenceDictionary R=/home/nicdemon/projects/def-banire/Labobioinfo/genomes/Canis_lupus/GCA_000002285.2_CanFam3.1_genomic.fasta O=/home/nicdemon/projects/def-banire/Labobioinfo/genomes/Canis_lupus/GCA_000002285.2_CanFam3.1_genomic.dict
#java -jar $EBROOTPICARD/picard.jar CreateSequenceDictionary R=/home/nicdemon/projects/def-banire/Labobioinfo/genomes/GCA_004886195.2/GCA_004886185_Basenji.fasta O=/home/nicdemon/projects/def-banire/Labobioinfo/genomes/GCA_004886195.2/GCA_004886185_Basenji.dict
#samtools faidx /home/nicdemon/projects/def-banire/Labobioinfo/genomes/Canis_lupus/GCA_000002285.2_CanFam3.1_genomic.fasta
#samtools faidx /home/nicdemon/projects/def-banire/Labobioinfo/genomes/GCA_004886195.2/GCA_004886185_Basenji.fasta

#Index vcf files
#gatk IndexFeatureFile -F /home/nicdemon/projects/def-banire/Labobioinfo/cermo/200203_silversides/db/canis_lupus_familiaris.vcf
#gatk IndexFeatureFile -F /home/nicdemon/projects/def-banire/Labobioinfo/cermo/200203_silversides/db/canis_lupus_familiaris_structural_variations.vcf

#Set WD
WORK_DIR=/home/nicdemon/projects/def-banire/Labobioinfo/cermo/200203_silversides/results/array
#List all bams in folder to file
if [ ! -f $WORK_DIR/files_BQSR_bam.txt ]; then
  for i in $WORK_DIR/"BQSR_"*".bam"; do
    echo $i >> $WORK_DIR/files_BQSR_bam.txt;
  done
fi

#Set file list to object
inputFiles=$WORK_DIR/files_BQSR_bam.txt
#Isolate each input file to job ID
file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $inputFiles)

ref=/home/nicdemon/projects/def-banire/Labobioinfo/genomes/Canis_lupus/GCA_000002285.2_CanFam3.1_genomic.fasta

out=$WORK_DIR/"After_$(basename -s .bam $file).table"
sites1=/home/nicdemon/projects/def-banire/Labobioinfo/cermo/200203_silversides/db/sorted_canis_lupus_familiaris.vcf
sites2=/home/nicdemon/projects/def-banire/Labobioinfo/cermo/200203_silversides/db/sorted_canis_lupus_familiaris_structural_variations.vcf

gatk BaseRecalibrator --java-options '-DGATK_STACKTRACE_ON_USER_EXCEPTION=true' -R $ref -I $file -O $out --known-sites $sites1 --known-sites $sites2 --disable-sequence-dictionary-validation

cd $SLURM_SUBMIT_DIR
echo $file $SLURM_TASK_ID $SLURM_ARRAY_TASK_ID >> _listTask_BQSR.txt
