#!/usr/bin/env python3
import csv,re

infile="lib/jgi_names.csv"
outfile="lib/jgi_names.tab"

with open(infile,"r") as ifh:
    with open(outfile,"w") as ofh:
        reader = csv.reader(ifh,delimiter=",")
        writer = csv.writer(ofh,delimiter="\t",lineterminator='\n')
        for line in reader:
            name=re.sub(" ","_",line[1])
            name=re.sub("\r","",name)
            writer.writerow([line[2],name])
