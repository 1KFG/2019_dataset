#!/usr/bin/env perl

use Bio::DB::Taxonomy;
use DB_File;

my %lookup;
my $cachefile = 'names.idx';

tie %lookup, "DB_File", $cachefile, O_RDWR|O_CREAT, 0666, $DB_HASH 
    or die "Cannot open file '$cachefile': $!\n";

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
    my ($name,$species,$strain,$clade,@rest) = split(/,/,$_);
    my ($genus,$sp) = split(/\s+/,$species);
    my $species_string = join(" ", $genus,$sp);
    my $str;
    if ( exists $lookup{$species_string} ) {
	$str = $lookup{$species_string};
    } else {
	print($species,$clade);
	my $h = $db->get_taxonid($species_string);
	my $node = $h;
	my @tax;
	while ( $node ) {
	    push @tax, [ $node->rank, $node->name('scientific')];
	    $ancestor = $node->ancestor;
	}
	$str = map { join(":",@{$_}) } ( reverse @tax );
	$lookup{$species_string} = $str;
    }
    print $str,"\n";
    last;
}

