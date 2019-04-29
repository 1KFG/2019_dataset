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
#	print join(";",($species,$clade)),"\n";
	my $h = $db->get_taxonid($species_string);
#	print("taxonid is $h\n");
	my $node = $db->get_taxon(-taxonid => $h);
	my @tax;
	my %ranks;
	while ( $node ) {	    
#	    print("rank=",$node->rank, ". node name is ",
#		  join(",",@{$node->name('scientific')},"\n"));
	    
	    if ( $node->rank ne 'no rank' ) {
		$ranks{$node->rank} = scalar @tax;
	    }

	    push @tax, [ $node->rank, @{$node->name('scientific')} ];
	    
	    $ancestor = $node->ancestor;
	    $node = $ancestor;
	}
	my $str = join(";", map { exists $ranks{$_} ?
				      join(":",@{$tax[$ranks{$_}]}) : '' }
		       qw(phylum subphylum class subclass family genus));
	$lookup{$species_string} = $str;
    }
    print join(",", $name,$species,$strain,$str,@rest),"\n";
}

