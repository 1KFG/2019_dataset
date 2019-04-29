#!/usr/bin/env perl
use strict;
use warnings;

my %names;
my $header = <>;
while(<>) {
    chomp;
    my ($name,$species,$strain,$clade,$source,@rest) = split(/,/,$_);
    push @{$names{$species}->{$strain}->{$source}} = [ $name,$species,$strain,$clade, $source, @rest];
}

print $header;

for my $sp ( keys %names ) {
    my @strains = keys %{$names{$sp}};
    if( scalar @strains == 1 ) {
	# how many strains how many sources for the strain
#	print join(",",$names{$sp}->{$sources[0]}),"\n";
    }
}
