#! /usr/bin/perl
# Author: Eric Lowe
# Usage: rita_to_ps.pl [input]
# Script to convert Rita results output to PhyloSift output 
# to enable benchmarking with PhyloSift and comparison between
# the two pieces of software. 

use strict;
use warnings;
use IO::File;

# if number of command-line arguments is incorrect print usage and exit                                       
if (($#ARGV + 1) != 1) {
    print "Wrong number of arguments!\n";
    print "usage: rita_to_ps.pl [input]\n";
    exit;
}

my $input = shift;
my $in_fh = IO::File->new("< $input")
    or die "Couldn't open $input for reading: $!";

my $output = name_output($input);




exit;



################### SUBROUTINES ###############################
###############################################################

# sub name_output                                                                                             
# Subroutine to appropriately name output file based on name of input file.                                   
# Takes in name of input file as a parameter.                                                                 
# Return value is string containing name of output file.                                                      
sub name_output {
    my $input = shift;
    my $name = '/home/elowe/PS_temp/';

    if ($input =~ 'knockoutunif') {
        $name .= 'knockoutunif_ill_fastq-reads_rita.fastq/sequence_taxa.txt';
    }
    elsif ($input =~ 'knockoutexp') {
        $name .= 'knockoutexp_ill_fastq-reads_rita.fastq/sequence_taxa.txt';
    }
    print "Output file name is $name\n";
    return $name;
} # sub name_output 

# sub read_file
#
sub read_file {


} # sub read_file


# sub write_output
#
sub write_output {

} # sub write_output


# sub write_header
#
sub write_header {
    my $file = shift; # local variable for output file                                                        
    my $ofh = IO::File->new("> $file")
        or die "Could not open $file for writing: $!";

    print $ofh "##Sequence_ID\tHit_Coordinates\tNCBI_Taxon_ID\tTaxon_Rank\tTaxon_Name\tProbability_Mass\tMarkers_Hit\n";

    $ofh->close;
} # sub write_header
