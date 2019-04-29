2019 frozen 1KFG genome dataset

Setup your version with your own JGI password
```
$ git clone https://github.com/1KFG/2019_dataset.git
$ cd 2019_dataset
$ mv scripts/init_jgi_download.sh.template scripts/init_jgi_download.sh
```
edit init_jgi_download.sh and addin your JGI username and password.
 
Download the fungi.xml file (or change the code to point to the clade you care about for faster service)
```
$ bash scripts/init_jgi_download.sh 
# or
$ chmod +x scripts/init_jgi_download.sh 
$ ./scripts/init_jgi_download.sh
```
I have previously defined a set of target taxa I want and their species names by parsing the fungi.html file you can get. It may need to be updated if there are more added. Alternatively if you only want some species you can edit this file to include only the ones you want to download
```
$ cp lib/jgi_fungi.csv lib/jgi_fungi.csv.backup
```
edit jgi_fungi.csv to be only the species you want

```
$ mkdir -p source/JGI
$ python scripts/jgi_download.py
```

if you are running on a machine with multiple processors and you want to parallelize downloading using the unix parallel tool
```
CPU=4 # e.g. 4 CPUs on this machine
$ cat lib/jgi_download.sh | parallel -j $CPU
```
Alternatively this will run in serial
```
$ bash lib/jgi_download.sh 
```
