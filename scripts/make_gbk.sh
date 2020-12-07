#!/usr/bin/bash
#SBATCH -p short -n 1 -N 1 --out logs/gbk.%a.log

CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
    CPU=$SLURM_CPUS_ON_NODE
fi

SAMPFILE=samples.csv
NUM=${SLURM_ARRAY_TASK_ID}

if [ -z $NUM ]; then
    NUM=$1
    if [ -z $NUM ]; then
        echo "need to provide a number by --array or cmdline"
        exit
    fi
fi

module load tbl2asn
module load ncbi_tools
module load funannotate
GFF=source/JGI/GFF
DNA=source/JGI/DNA
TBL=source/JGI/GBK

ls $GFF/*.gff3  | sed -n ${NUM}p | while read gff 
do
	b=$(basename $gff .gff3)
	N=$(grep -w $b lib/jgi_names.tab | awk '{print $2}' | perl -p -e 's/_/ /g')
	funannotate util gff2tbl -g $gff -f $DNA/$b.nt.fasta | perl -p -e 's/jgi\.p\|([^\|]+)\|/$1_/' > $TBL/$b.tbl
	ln -s $(realpath $DNA/$b.nt.fasta) $TBL/$b.fsa
	tbl2asn -p $TBL -V b  -M n -r $TBL -n "$N"
done


