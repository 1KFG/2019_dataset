#!/usr/bin/bash

#SBATCH --nodes 1 --ntasks 1 --mem 8G --out ens_make_table.log

tmpdir='tmp'
mkdir -p $tmpdir/taxa
if [ ! -f $tmpdir/taxdump.tar.gz ]; then
    pushd $tmpdir/taxa
    curl -O ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz
    tar zxf taxdump.tar.gz
    popd
fi



