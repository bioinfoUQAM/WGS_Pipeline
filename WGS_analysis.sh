#!/bin/bash
#SBATCH --job-name=BCF_annotate_ISEC
#SBATCH --account=def-banire
#SBATCH --mem=64G
#SBATCH --array=1-13
#SBATCH --output=/home/nicdemon/projects/def-banire/nicdemon/scripts/%x_%a.out
#SBATCH --error=/home/nicdemon/projects/def-banire/nicdemon/scripts/%x_%a.err
#SBATCH --time=12:00:00

cd $SLURM_SUBMIT_DIR
module load nixpkgs/16.09 python/3.8.2

#Create virtual environment
python3 -m venv WGS_analysis

#Activate virtual environment
source WGS_analysis/bin/activate

#Install ressources
pip3 install snakemake

#Set WD
WORK_DIR=PATH/TO/DIR
