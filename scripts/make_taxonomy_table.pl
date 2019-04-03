#!/usr/bin/env perl

use Bio::DB::Taxonomy;

my $namesfile = 'tmp/taxa/names.dmp';
my $nodesfile = 'tmp/taxa/nodes.dmp';
my $indexdir  = 'indexes';
if ( ! -d $indexdir ) {
    mkdir($indexdir);
}
if ( -f "$indexdir/nodes") {
    $db = Bio::DB::Taxonomy->new(-source      => 'flatfile', 
				 -directory   => $indexdir);
    
} else {
    $db = Bio::DB::Taxonomy->new(-source      => 'flatfile', 
				-directory   => $indexdir,
				-nodesfile   => $nodesfile, 
				-namesfile   => $namesfile);
}
my $header = <>;
while(<>) {
    chomp;

    my ($prefix,$species) = split(/,/,$_);
    print($prefix,$species);
    my $h = $db->get_taxonid($species);
    my $node = $h;
    my @tax;
    while( $node ) {
	push @tax, [ $node->rank, $node->name('scientific')];
	$ancestor = $node->ancestor;
    }
    for my $r ( reverse @tax ) {
	print join(":",@$r),"\n";
    }
    last;
}

