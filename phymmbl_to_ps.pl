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
if (($#ARGV + 1) < 2) {
    print "Wrong number of arguments!\n";
    print "usage: phymmbl_to_ps.pl [input] [output]\n";
    exit;
}
my $prefix1 = q(); # initialize prefix variables to empty strings
my $prefix2 = q();
my $input   = shift; # variable for input file
my $output  = shift; # variable for output file, to be replaced by return value of subroutine

# if optional third argument given
if ($ARGV[2]) {
    $prefix1 = $ARGV[2];
    $prefix2 = $prefix1;
}
else {
    $prefix1 = '/home/elowe/ncbi';
    $prefix2 = '/home/elowe/bin/phymmbl/.taxonomyData/.0_accessionMap';
}

my $catalog_file = "$prefix1/RefSeq-release54.catalog";
my $phymmbl_file = "$prefix2/accessionMap.txt";
my $ncbi_org_ref = get_ncbi_accessions($catalog_file);
my $phymmbl_org_ref = get_phymmbl_accessions($phymmbl_file);

read_in($ncbi_org_ref, $phymmbl_org_ref, $input, $output);

exit;

######################SUBROUTINES##########################
###########################################################



sub get_ncbi_accessions {
    my $file = shift;
    my $catalog_fh = IO::File->new("< $file")
        or die "Couldn't open $file for reading: $!";
        
    my %ncbi_organism;
    while (<$catalog_fh>) {
        chomp(my $line = $_);
        $line =~ s/ //g;
        my @fields = split('\t', $line);
        $fields[2] =~ s/\.\d//g;
        
        if (! defined $ncbi_organism{ $fields[2] }) {
            $ncbi_organism{ $fields[2] } = [ $fields[1], $fields[0] ];
        }
        else {
            print "We've seen $fields[2] before!\n";
        }
    }
    return \%ncbi_organism;
    
} # sub get_ncbi_accessions

sub get_phymmbl_accessions {
    my $file = shift;
    my $phymmbl_fh = IO::File->new("< $file")
        or die "Couldn't open $file for reading: $!";
        
    my %phymmbl_organism;
    
    while (<$phymmbl_fh>) {
        chomp(my $line = $_);
        $line =~ s/ //g;
        my @fields = split('\t', $line);
        
        if (! defined $phymmbl_organism{ $fields[0] }) {
            $phymmbl_organism{ $fields[0] } = [ $fields[1] ];
        }
        else {
            push @{ $phymmbl_organism{$fields[0]} }, $fields[1];
        }
    }
    return \%phymmbl_organism;
} # sub get_phymmbl_accessions

# sub read_in
# Subroutine to read input PhymmBL file and extracts data from it appropriately.
# Takes reference to %named, %taxed and $input as parameters.
# Has no return value as of yet.
sub read_in {
    my $ncbi_ref = shift; # reference to %named
    my $phymmbl_ref = shift; # reference to %taxed
    my $input_file = shift;
    my $output_file = shift;
    
    # input file filehandle
    my $infh = IO::File->new("< $input_file") 
	   or die "Could not open $input_file for reading: $!"; 

    while (<$infh>) {
	   next if $_ =~ 'QUERY_ID'; # skip first line of file
	   chomp(my $line = $_);
	   my @field = split('\t', $line);
	   my $name = q();
	   my $read_id = q();
	   my $taxon_id = q();
	   
	   if (! defined $$phymmbl_ref{$field[1]}) {
	       print "Undefined name: $field[1]\n";
	   }
	   else {
	       #print "Defined name: $field[1]\n";
	       my $accession = $$phymmbl_ref{$field[1]};
	       $name = $ncbi_ref->{$accession}[0];
           $read_id = $field[0];
           $taxon_id = $ncbi_ref->{$accession}[1];
           write_out($name, $read_id, $taxon_id, $output_file);
	   }
#	print "$field[1], $field[0], $$taxed_ref{$field[1]}\n";
    }
    $infh->close; # closes input file filehandle
} # sub read_in


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
    my $name = shift;
    my $read_id = shift;
    my $taxon_id = shift;
    my $file = shift; # local variable for output file
    my $ofh = IO::File->new(">> $file") 
	   or die "Could not open $file for writing: $!";
	   
	print $ofh "$read_id\t$taxon_id\tno rank\t$name\t1\tconcat\n";

    $ofh->close;
} # sub write_out

