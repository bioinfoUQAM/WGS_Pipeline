#!/bin/bash
#SBATCH --job-name=BCFtools
#SBATCH --account=def-banire
#SBATCH --mem=191000M
#SBATCH --array=1-4
#SBATCH --output=/home/nicdemon/projects/def-banire/nicdemon/scripts/%x_%a.out
#SBATCH --error=/home/nicdemon/projects/def-banire/nicdemon/scripts/%x_%a.err
#SBATCH --time=24:00:00

cd $SLURM_SUBMIT_DIR
module load nixpkgs/16.09 intel/2018.3 gatk/4.1.2.0 samtools/1.10 bcftools/1.10.2 mugqic/python/3.7.3

#Set WD
WORK_DIR=/home/nicdemon/projects/def-banire/nicdemon/results

#Set file list to object
inputFiles=$WORK_DIR/files_varCall_bam.txt
#Isolate each input file to job ID
file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $inputFiles)
pileup=$WORK_DIR/"BCFtools_$(basename -s .bam $file).vcf.gz"
snp=$WORK_DIR/"SNP_$(basename -- $pileup)"
cnv=$WORK_DIR/"CNV_$(basename -- $pileup)"

#Set reference
if [[ "$(basename -- $file)" == *"bas_mem2.bam" ]]; then
  ref=/home/nicdemon/projects/def-banire/nicdemon/db/GCA_004886185_Basenji.fasta
elif [[ "$(basename -- $file)" == *"can_mem2.bam" ]]; then
  ref=/home/nicdemon/projects/def-banire/nicdemon/db/GCA_000002285.2_CanFam3.1_genomic.fasta
fi

#BCFtools pileup depending on reference & file
#test pileup pour varscan qui n'est plus compatible avec le format du fichier...
#bcftools mpileup -f $ref --threads 48 -o $pileup $file
#test vcf
bcftools mpileup -O z --threads 48 -o $pileup -f $ref $file

#Run BCFtools SNV calling
bcftools call -mO z --threads 48 -o $snp $pileup

#Index vcf after creation
gatk IndexFeatureFile -F $snp

#Run BCFtools CNV calling
bcftools cnv -o $WORK_DIR $pileup

#Optional stats + plots output
#Run BCFtools stats/analysis of cnv
#bcftools stats -F $ref --threads 48 $pileup > $WORK_DIR/"$(basename -s .vcf.gz $pileup).vchk"
#BCFtools plots of stats
#for i in $WORK_DIR/*.vchk; do
#  plot-vcfstats -p $WORK_DIR $i;
#  mv summary.pdf "$(basename -s .vchk $i).pdf"
#done

cd $SLURM_SUBMIT_DIR
echo $file $SLURM_TASK_ID $SLURM_ARRAY_TASK_ID >> _listTask_VarScan.txt
