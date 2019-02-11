#!/usr/bin/bash
#SBATCH -p stajichlab --ntasks 1 --mem 2G

module load python/3

python scripts/ensembl_download.py -t pep
