# WGS_Pipeline
Pipeline for analysis of DNA-seq on Compute Canada HPC servers.

Authors : Nicolas de Montigny, Golrokh Kiani
Professor : Abdoulaye Banire Diallo
Organisation : Labobioinfo UQAM

#Installation
##Dependencies
The pipeline depends on usage of python3 in a virtual environment.
To install the virtual environment you will need python3 installed/loaded if on HPC.
To load the module on HPC.
```
module load nixpkgs/16.09 python/3.8.2
```
Then to create the virtual environment using python3 and activate it
```
python3 -m venv WGS_analysis
source WGS_analysis/bin/activate
```
Install python3 ressources with pip
```
pip3 install snakemake
```
