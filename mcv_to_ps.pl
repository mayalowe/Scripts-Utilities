#! /usr/bin/perl
# Author: Eric Lowe
# Usage: mcv_to_ps.pl [input file] > [output file]
# Script to convert MetaCV output to PS output for benchmarking 
# and comparison.

use strict; 
use warnings;

my $input = shift;
open my $fh, $input or die "Couldn't open file: $!";

# print header line for sequence_taxa.txt
print "##Sequence_ID\tHit_Coordinates\tNCBI_Taxon_ID\tTaxon_Rank\tTaxon_Name\tProbability_Mass\tMarkers_Hit\n";
while(<$fh>)
{
    chomp(my $line = $_);
    $line =~ s/ //g; # remove spaces from line
    my @fields = split('\t', $line); # get fields from tab-delimited line
    
    if($fields[5] =~ '_') # skip lines missing info for taxid
    {
	next;
    }
    print "$fields[0]\t2.71828\t$fields[5]\tno rank\t$fields[6]\t1\tconcat\n";
}

exit;
