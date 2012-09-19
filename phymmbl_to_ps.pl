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

if (($#ARGV + 1) != 2) # if number of command-line arguments is incorrect print usage and exit
{
    print "Wrong number of arguments!\n";
    print "usage: phymmbl_to_ps.pl [input] [output]\n";
    exit;
}

my $input = shift; # variable for input file
my $output = shift; # variable for output file, to be replaced by return value of subroutine
my $names = "/home/elowe/ncbi/names.dmp"; # path to nodes.dmp

my %taxed = (); # hash with keys names and values taxids
fill_names(\%taxed, $names);

my %named;
read_in(\%named, \%taxed, $input);

write_out($output); # calls subroutine to write out to file

exit;

######################SUBROUTINES##########################
###########################################################

# sub fill_names
# Subroutine to populate hash with names and taxids
# from names.dmp to convert PhymmBL output to PS output.
# Takes reference to %taxed and $names as parameters. 
# Has no return value as of yet.
sub fill_names
{
    my $ref = shift; # reference to %taxed
    my $file = shift;
# Check here for how recent names.dmp is?
    # names.dmp filehandle
    my $nfh = IO::File->new("< $file") or die "Could not open names.dmp for reading: $!"; 

    while(<$nfh>)
    {
	chomp(my $line = $_);
	$line =~ s/\|//g; # remove | from line
	$line =~ s/ //g; # remove whitespace
	my @field = split('\t', $line); # split on tabs to fill array with fields

	if(! defined $$ref{$field[2]})
	{
	    $$ref{$field[2]} = $field[0];
	}
    }

    $nfh->close; # closes names.dmp filehandle
} # sub fill_names

# sub read_in
# Subroutine to read input PhymmBL file and extracts data from it appropriately.
# Takes reference to %named, %taxed and $input as parameters.
# Has no return value as of yet.
sub read_in
{
    my $nref = shift; # reference to %named
    my $tref = shift; # reference to %taxed
    my $file = shift;
    # input file filehandle
    my $infh = IO::File->new("< $file") or die "Could not open $file for reading: $!"; 

    while(<$infh>)
    {
	next if $_ =~ 'QUERY_ID'; # skip first line of file
	chomp(my $line = $_);
	my @field = split('\t', $line);
	print "$field[1], $field[0]\n";
    }

    $infh->close; # closes input file filehandle
} # sub read_in

# sub name_output
# Subroutine to appropriately name output file based on name of input file.
# Takes in name of input file as a parameter.
# Return value is string containing name of output file.
sub name_output
{
    my $in = shift;
    my $name;

    return($name);
}

# sub write_out 
# Subroutine to write out to a file in PS format.
# Takes $output as the only parameter. 
# Has no return value, closes output file at end of sub.
sub write_out
{
    my $file = shift; # local variable for output file
    my $ofh = IO::File->new("> $file") or die "Could not open $file for writing: $!";

    $ofh->close;
} # sub write_out

