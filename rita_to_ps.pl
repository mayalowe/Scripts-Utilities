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
my $ncbi_file = '/home/elowe/ncbi/names.dmp';
my $output = name_output($input);

my $organism_ref = get_taxids($ncbi_file);
read_file($input, $organism_ref);


exit;

################### SUBROUTINES ##########################################
##########################################################################

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
    my $file = shift;
    my $hashref = shift;
    my $ifh = IO::File->new("< $file")
        or die "Couldn't open file for reading: $!";
    
    while (<$ifh>) {
        chomp(my $line = $_);
        
        my @fields = split('\t', $line);
        my $read = $fields[0];
        my $name = pop @fields;
        $name =~ s/_/ /g; # either need to do more formatting of names or need to find name source
        print "read: $read, name: $name\n";
    }

    $ifh->close;
} # sub read_file


# sub write_output
#
sub write_output {
    my $file = shift;
    my $ofh = IO::File->new(">> $file")
        or die "Couldn't open $file for writing: $!";


    $ofh->close;
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

# sub get_taxids
#
sub get_taxids {
    my $file = shift;
    my $ifh = IO::File->new("< $file")
        or die "Could not open $file for reading: $!";

    my %ncbi_organism;

    while (<$ifh>) {
        chomp(my $line = $_);

        my @fields = split('\t\|\t', $line);

        if ( !defined $ncbi_organism{$fields[1]} ) {
            $ncbi_organism{$fields[1]} = $fields[0];
        }
        else {
#            print "Offender: $fields[1], $fields[0]\n";
 #           print "Defined: $ncbi_organism{$fields[1]}\n";
        }
    }
    $ifh->close;
    return \%ncbi_organism;
} # sub get_taxids
