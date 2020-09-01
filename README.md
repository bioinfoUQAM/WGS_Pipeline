# WGS_Pipeline
Pipeline for analysis of DNA-seq on Compute Canada HPC servers.

Authors : Nicolas de Montigny, Golrokh Kiani
Professor : Abdoulaye Banire Diallo
Organisation : Labobioinfo UQAM

# Installation
## Dependencies
The pipeline depends on usage of python3 in a virtual environment.
To install the virtual environment you will need Miniconda3 installed if on HPC.

1. Run the following on the command line: `wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh`.
2. Once the download has finished, run: `bash Miniconda3-latest-Linux-x86_64.sh` and follow the on-screen instructions. Press `enter` when asked where to install miniconda3 (or specify location).
3. Add the folder `/home/$USERNAME/miniconda3/bin` to your `~/.bash_profile` to easily access your conda
3. Use the environment file to download and install all necessary packages for this workshop into a conda environment:
```
conda create -n WGS_pipeline -f smk_542_env.yaml.
```

First setup of snakemake for dev
```
conda install -c conda-forge mamba
conda create -n WGS_pipeline
mamba install -n WGS_Pipeline bioconda::snakemake
```


# ***Using venv***
To load the module on HPC.
```
module load nixpkgs/16.09 python/3.8.2
```
Download and Then to create the virtual environment using python3 and activate it
```
python3 -m venv WGS_analysis
source ~/WGS_analysis/bin/activate
```
Install python3 ressources with pip
```
pip3 install -r requirements.txt
```

# Usage
- Examples
- References (if needed)
