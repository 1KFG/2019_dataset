#!/usr/bin/env python3

import os, sys, argparse
from ftplib import FTP
import shutil
import tempfile
import urllib.request

Validseq = ['dna','pep','cds']

def download_gtf(ftp_h,remote_dir, local_dir, debug):

    for speciesdir in ftp_h.nlst(remote_dir):
        bname=os.path.basename(speciesdir)
        if bname.startswith('fungi_'):
            # collection folder
            print("fungidir %s"%(speciesdir))
            for colspecies in ftps.nlst(speciesdir):
                
                for gtf in ftps.nlst(colspecies):
                    if ('chromosome.' not in gtf and 'chr.' not in gtf and
                        gtf.endswith(".gtf.gz")):
                        targetfile = os.path.join(local_dir,
                                                  os.path.basename(gtf))
                        if debug:
                            print("get %s to %s" %(gtf,targetfile))

                        if not os.path.exists(targetfile):
                            ftps.retrbinary("RETR %s"%(gtf),
                                            open(targetfile,"wb").write)

        else:
            if debug:
                print(speciesdir)

            for gtf in ftps.nlst(speciesdir):
                if ( 'chr.' not in gtf and 'chromosome.' not in gtf and
                     gtf.endswith(".gtf.gz")):
                    targetfile = os.path.join(local_dir,os.path.basename(gtf))
                    if not os.path.exists(targetfile):
                        if args.debug:
                            print("get %s to save in %s" %(gtf,targetfile))
                            ftps.retrbinary("RETR %s"%(gtf),
                                            open(targetfile,"wb").write)

def download_fasta(ftp_h, remote_dir, local_dir, seqtype, debug):
    if seqtype not in Validseq:
        print("need seqtype to be one of %s - %s provided" %(",".join(Validseq),
                                                             seqtype))
    for speciesdir in ftps.nlst(remote_dir):
        print(speciesdir)
        bname=os.path.basename(speciesdir)
        print(bname)
        if bname.startswith('fungi_'):
        # collection folder
            print("fungidir %s"%(speciesdir))
            for colspecies in ftps.nlst(speciesdir):
                for seqfile in ftps.nlst(os.path.join(colspecies,seqtype)):
                    targetfile = os.path.join(local_dir,
                                              os.path.basename(seqfile))
                    if seqtype is 'pep' and seqfile.endswith(".all.fa.gz"):
                        if args.debug:
                            print("get %s to %s" %(seqfile,targetfile))

                        if not os.path.exists(targetfile):
                            ftps.retrbinary("RETR %s"%(seqfile),
                                            open(targetfile,"wb").write)
                    elif ( seqtype is 'dna' and 
                           seqfile.endswith('.dna_sm.toplevel.fa.gz')):
                        if args.debug:
                            print("get %s to %s" %(seqfile,targetfile))

                        if not os.path.exists(targetfile):
                            ftps.retrbinary("RETR %s"%(seqfile),
                                            open(targetfile,"wb").write)
                    elif ( seqtype is 'cds' and 
                           seqfile.endswith(".cds.all.fa.gz")):
                        if args.debug:
                           print("get %s to %s" %(seqfile,targetfile))
                        if not os.path.exists(targetfile):
                           ftps.retrbinary("RETR %s"%(seqfile),
                                           open(targetfile,"wb").write)
        else:
            if debug:
                print(speciesdir)
            for seqfile in ftps.nlst(os.path.join(speciesdir,seqtype)):
                targetfile = os.path.join(local_dir,
                                          os.path.basename(seqfile))
                if seqtype is 'pep' and seqfile.endswith(".all.fa.gz"):
                    if args.debug:
                        print("get %s to %s" %(seqfile,targetfile))
                    if not os.path.exists(targetfile):
                        ftps.retrbinary("RETR %s"%(seqfile),
                                            open(targetfile,"wb").write)
                elif ( seqtype is 'dna' and 
                       seqfile.endswith('.dna_sm.toplevel.fa.gz')):
                    if args.debug:
                        print("get %s to %s" %(seqfile,targetfile))

                    if not os.path.exists(targetfile):
                        ftps.retrbinary("RETR %s"%(seqfile),
                                        open(targetfile,"wb").write)

host='ftp.ensemblgenomes.org'

parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter, description='Download Ensembl Fungal dataset')

parser.add_argument('-v','--verbose', dest='debug',
                    action='store_true',
                    help='Verbosity of output')

parser.add_argument('-r','--release', dest='releasenum',
                    type=int, default=44,required=False,
                    help='Release version to download')

parser.add_argument('-t','--type',dest='featuretype', nargs='+',
                    type=str, default='gff',required=False,
                    help='Feature type to download')

parser.add_argument('-o','--out',dest='outdir', 
                    type=str, default='source/Ensembl',required=False,
                    help='Output datadir')

args = parser.parse_args()


ftps = FTP(host)
ftps.login()
basefolder="/pub/release-%d/fungi/"%(args.releasenum)

url_base = "ftp://%s/"%(host)

# get gff and gtf
GTF_local = os.path.join(args.outdir,"GTF")
if not os.path.exists(GTF_local):
    os.mkdir(GTF_local)

pep_local = os.path.join(args.outdir,"pep")
if not os.path.exists(pep_local):
    os.mkdir(pep_local)

DNA_local = os.path.join(args.outdir,"DNA")
if not os.path.exists(DNA_local):
    os.mkdir(DNA_local)

CDS_local = os.path.join(args.outdir,"CDS")
if not os.path.exists(CDS_local):
    os.mkdir(CDS_local)

print(args.featuretype)

if 'gff' in args.featuretype:
    gtf_dir=os.path.join(basefolder,'gtf')
    download_gtf(ftps, gtf_dir, GTF_local, args.debug)

if 'dna' in args.featuretype:
    fasta_dir=os.path.join(basefolder,'fasta')
    download_fasta(ftps, fasta_dir, DNA_local, 'dna', args.debug)

if 'pep' in args.featuretype:
    fasta_dir=os.path.join(basefolder,'fasta')
    download_fasta(ftps, fasta_dir, pep_local, 'pep', args.debug)


if 'cds' in args.featuretype:
    fasta_dir=os.path.join(basefolder,'fasta')
    download_fasta(ftps, fasta_dir, CDS_local, 'cds', args.debug)


        

