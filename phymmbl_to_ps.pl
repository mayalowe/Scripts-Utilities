#! /usr/bin/perl
# Author: Eric Lowe
# Usage: phymmbl_to_ps.pl [input] [output]
# perl script to convert phymmbl output to PS output

use strict;
use warnings;
use IO::File;
#use File::stat;
#use Net::FTP;
#use Cwd;

# if number of command-line arguments is incorrect print usage and exit
if (($#ARGV + 1) != 2) {
    print "Wrong number of arguments!\n";
    print "usage: phymmbl_to_ps.pl [input] [output]\n";
    exit;
}

my $input        = shift; # variable for input file
my $output       = shift; # variable for output file, to be replaced by return value of subroutine
my $prefix       = '/home/elowe';
my $names_file   = "$prefix/ncbi/names.dmp"; # path to nodes.dmp
my $catalog_file = "$prefix/ncbi/RefSeq-release54.catalog";
my $phymmbl_file = "$prefix/bin/phymmbl/.taxonomyData/.0_accessionMap/accessionMap.txt";
my %taxed        = (); # hash with keys names and values taxids

taxid_from_accession($catalog_file, $phymmbl_file);
fill_names(\%taxed, $names_file);

#my %named;
read_in(\%taxed, $input, $output);

#write_out($output); # calls subroutine to write out to file

exit;

######################SUBROUTINES##########################
###########################################################

# sub fill_names
# Subroutine to populate hash with names and taxids
# from names.dmp to convert PhymmBL output to PS output.
# Takes reference to %taxed and $names as parameters. 
# Has no return value as of yet.
sub fill_names {
    my $taxed_ref = shift; # reference to %taxed
    my $file = shift;
# Check here for how recent names.dmp is?
    # names.dmp filehandle
    my $names_fh = IO::File->new("< $file") 
	or die "Could not open names.dmp for reading: $!"; 

    while (<$names_fh>) {
	chomp(my $line = $_);
	$line =~ s/\|//g; # remove | from line
	$line =~ s/ //g; # remove whitespace
	my @field = split('\t', $line); # split on tabs to fill array with fields

	if (! defined $$taxed_ref{$field[2]}) {
	    $$taxed_ref{$field[2]} = $field[0];
	}
    }

    $names_fh->close; # closes names.dmp filehandle
} # sub fill_names

# sub read_in
# Subroutine to read input PhymmBL file and extracts data from it appropriately.
# Takes reference to %named, %taxed and $input as parameters.
# Has no return value as of yet.
sub read_in {
#    my $named_ref = shift; # reference to %named
    my $taxed_ref = shift; # reference to %taxed
    my $input_file = shift;
    my $output_file = shift;
    # input file filehandle
    my $infh = IO::File->new("< $input_file") 
	or die "Could not open $input_file for reading: $!"; 

    while (<$infh>) {
	next if $_ =~ 'QUERY_ID'; # skip first line of file
	chomp(my $line = $_);
	my @field = split('\t', $line);
	if (! defined $$taxed_ref{$field[1]}) {
	    print "Undefined name: $field[1]\n";
	}
	else {
	    print "Defined name: $field[1]\n";
	}
#	print "$field[1], $field[0], $$taxed_ref{$field[1]}\n";
#	my $hash_ref = { 
#	    name => "$field[1]",
#	    read_id => "$field[0]",
#	    taxon_id => "$$taxed_ref{$field[1]}",
#	}
    }

    $infh->close; # closes input file filehandle
} # sub read_in


# sub find_accession
#
sub find_accession {
    my $organism_name = shift;

    

}
# sub taxid_from_accession
# Because PhymmBl doesn't play nice, finds taxid from
# given mangled name and RefSeq Accession using PhymmBL
# files and NCBI file
sub taxid_from_accession {
    my $catalog = shift;
    my $phymmbl = shift;
    my $phymmbl_fh = IO::File->new("< $phymmbl")
	or die "Couldn't open $phymmbl for reading: $!";
    my $catalog_fh = IO::File->new("< $catalog")
	or die "Couldn't open $catalog for reading: $!";

    

    $phymmbl_fh->close;
    $catalog_fh->close;

} # sub taxid_from_accession

# sub name_output
# Subroutine to appropriately name output file based on name of input file.
# Takes in name of input file as a parameter.
# Return value is string containing name of output file.
sub name_output {
    my $in = shift;
    my $name;

    return($name);
}

# sub write_out 
# Subroutine to write out to a file in PS format.
# Takes $output as the only parameter. 
# Has no return value, closes output file at end of sub.
sub write_out {
    my $line_ref = shift;
    my $file = shift; # local variable for output file
    my $ofh = IO::File->new(">> $file") 
	or die "Could not open $file for writing: $!";

    $ofh->close;
} # sub write_out

