#!/usr/bin/bash

pushd source/JGI/GFF3
zgrep -c start_codon *.gff3.gz > start_grep.txt
sort -t":" -k2,2n start_grep.txt  | grep -v :0 | cut -d: -f1
