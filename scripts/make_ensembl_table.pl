#!/usr/bin/env perl
use strict;
use warnings;
use Bio::DB::Taxonomy;
use DB_File;

my %lookup;
my $cachefile = 'names.idx';

tie %lookup, "DB_File", $cachefile, O_RDWR | O_CREAT, 0666, $DB_HASH
  or die "Cannot open file '$cachefile': $!\n";

my $namesfile = 'tmp/taxa/names.dmp';
my $nodesfile = 'tmp/taxa/nodes.dmp';

my $db = Bio::DB::Taxonomy->new(
        -source    => 'sqlite',
        -nodesfile => $nodesfile,
        -namesfile => $namesfile,
);

my $dir = shift      || 'source/Ensembl/pep';
opendir( DIR, $dir ) || die $!;
print join( ",", qw(NAME GENUS SPECIES STRAIN TAXONOMY)),"\n";

foreach my $file ( readdir(DIR) ) {
    next if $file =~ /^\./;
    my ( $genus, $species, $strain, $spname );

    if ( $file =~ /^(\S+)_gca_/ || $file =~ /^(\S+)\.GCA_/ ) {
        $spname = $1;
    } else {
        ($spname) = split( /\./, $file );
    }
    ( $genus, $species, $strain ) = split( /_/, $spname, 3 );
    my $species_string = join( " ", $genus, $species );
    warn("species string is $species_string\n");
    my $str;
    if ( exists $lookup{$species_string} ) {
        $str = $lookup{$species_string};
    } else {
        my $h = $db->get_taxonid($species_string);
        #warn("taxonid is $h\n");

        if ( !$h ) {
            $h = $db->get_taxonid($genus);
            warn("going to search for genus '$genus' since '$species_string' didn't work");
        }
        my $node = $db->get_taxon( -taxonid => $h );

        if ($node) {
            my @tax;
            my %ranks;
            while ($node) {

                #	    print("rank=",$node->rank, ". node name is ",
                #		  join(",",@{$node->name('scientific')},"\n"));

                if ( $node->rank ne 'no rank' ) {
                    $ranks{ $node->rank } = scalar @tax;
                }

                push @tax, [ $node->rank, @{ $node->name('scientific') } ];

                my $ancestor = $node->ancestor;
                $node = $ancestor;
            }
            my $str = join(
                ";",
                map {
                    exists $ranks{$_}
                      ? join( ":", @{ $tax[ $ranks{$_} ] } )
                      : ''
                } qw(phylum subphylum class subclass family genus)
            );
            $lookup{$species_string} = $str;
        }
        else {
            $str = "";
        }
    }
    print join( ",", $spname, $genus,$species,$strain || '', $str || ''), "\n";
}
