#!/usr/bin/bash
#SBATCH -p stajichlab --nodes 1 --ntasks 64 --mem 32G --out logs/summarize_genomes.%A.log

Rscript Rscripts/summarize_genomes.R
