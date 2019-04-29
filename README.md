2019 frozen 1KFG genome dataset

Setup your version with your own JGI password
```
$ git clone https://github.com/1KFG/2019_dataset.git
$ cd 2019_dataset
$ mv scripts/init_jgi_download.sh.template scripts/init_jgi_download.sh
```
edit init_jgi_download.sh and addin your JGI username and password.
 
Download the fungi.xml file (or edit the code change the code in init_jgi_download.sh to be 'pezizomycotina' instead of 'fungi' to point to the clade you care about for faster service)
```
$ bash scripts/init_jgi_download.sh 
# or
$ chmod +x scripts/init_jgi_download.sh 
$ ./scripts/init_jgi_download.sh
$ mkdir -p source/JGI
$ python scripts/jgi_download.py
```
This creates a file in lib/jgi_download.sh which are a series of 'curl' commands to download GFF, DNA, and CDS. The parsing of the XML does its best but the JGI files are not entirely consistent as to how to encode the presence of multiple versions of an annotation per species. They do not encode 'best and latest' as a category so it is difficult to totally know how to pull the correct one out. So you should check over and make sure you did get what was expected for many. There is a table provided in lib/jgi_fungi.csv to check what was selected. 

If you are running on a machine with multiple processors and you want to parallelize downloading using the unix parallel tool
```
CPU=4 # e.g. 4 CPUs on this machine
$ cat lib/jgi_download.sh | parallel -j $CPU
```
Alternatively this will run in serial
```
$ bash lib/jgi_download.sh 
```
