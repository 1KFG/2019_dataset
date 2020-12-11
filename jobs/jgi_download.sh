#!/usr/bin/bash
#SBATCH -p batch --nodes 1 --ntasks 8 --mem 8G --out jgi_download.log
module unload perl
module load parallel
CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
fi
cat lib/jgi_download.sh | parallel -j $CPU 
