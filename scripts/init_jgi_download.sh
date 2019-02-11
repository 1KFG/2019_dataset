#!/usr/bin/bash
#SBATCH -p stajichlab --ntasks 1 --nodes 1 --mem 2G --time 8:00:00 -o download_fungixml.log

curl 'https://signon-old.jgi.doe.gov/signon/create' --data-urlencode 'login=jason.stajich@ucr.edu' --data-urlencode 'password=Ey6fEzwheZIcvuqJ' -c cookies > /dev/null 

if [ ! -f lib/fungi.xml ]; then
    curl 'https://genome.jgi.doe.gov/portal/ext-api/downloads/get-directory?organism=fungi&organizedByFileType=true' -b cookies > lib/fungi.xml
fi
