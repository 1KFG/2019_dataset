#!/usr/bin/bash
#SBATCH -p stajichlab --ntasks 1 --mem 2G

module unload miniconda2
module load miniconda3
python scripts/ensembl_download.py -t cds
