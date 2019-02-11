#!/usr/bin/env perl

use Bio::DB::Taxonomy;

my $namesfile = 'tmp/taxa/names.dmp';
my $nodesfile = 'tmp/taxa/nodes.dmp';
my $indexdir  = 'tmp/indexes';
if ( ! -d $indexdir ) {
    mkdir($indexdir);
}
my $db = Bio::DB::Taxonomy->new(-source      => 'flatfile', 
				-directory   => $indexdir,
				-nodesfile   => $nodesfile, 
				-verbose     => 1,
				-namesfile   => $namesfile);

print ($db),"\n";
