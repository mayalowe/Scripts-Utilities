#! /usr/bin/perl
# Author: Eric Lowe
# Usage: perl megan_db.pl [input file] [knockout file] [gi file]
# Script to create a custom db for MEGAN
# Extreme work in progress

use strict; use warnings;

my $kofile = shift;
my $gifile = shift;


# get an array with ko id's from subroutine
my @ko = get_koed($kofile);

# $data is a reference to a hash returned from the sub
# get_gi. this hash has keys of taxids and values of arrays
# with each element as a gi.
my $data = get_gi($gifile);
my %nhash = %$data;         # stores hash into hash %nhash


list_files_ebi(@ko);
list_files_draft(@ko);


exit;

###################### SUBROUTINES ########################

# get_koed($kofile)
# sub get_koed takes in a file containing a list of taxon 
# id's that you would like to exclude from your BLAST run
# Returns an array with each element containing a separate 
# taxid.

sub get_koed
{
    my $in = shift;
    open my $fh, $in or die "Couldn't open knockout file $in: $!";
    
    # slurp knockout file into an array
    my @array = <$fh>;
    # close the filehandle
    close $fh;
    return @array;
}

# get_gi($gifile)
# sub gi_from_taxid takes a file with a list of GenBank ID's 
# and Taxon IDs and finds the corresponding GenBank ID 
# for each Taxon ID.

sub get_gi
{
    my $gi = shift;
    open my $fh, $gi or die "Couldn't open GenBank ID file $gi: $!";
    
    #my $stamp = ctime(stat($fh)->mtime);
    #print "$stamp\n";
    my %hash;
    
    while (<$fh>) 
    {
	my $line = $_;
	
	if ($line =~ /(\d+)\s+(\d+)/) 
	{
	    if (! defined $hash{$2})
	    {
		$hash{$2} = [$1];
	    } else {
		push (@{$hash{$2}}, $1);
	    }
	}
    }
    
    close $fh;
    return \%hash;
}
    
# sub list_files_ebi
# This sub and the following are essentially the same
# if this script was longer or if I was less lazy I
# would make them objects, but here we are.
# Oh well.

sub list_files_ebi
{
    my @array = shift;
    my $dir = "/share/eisen-d2/amphora2/ebi";
    opendir my $dh, $dir or die "Couldn't open directory $dir: $!";

    my @files = readdir $dh;
#    print "@files\n";
    foreach my $file (@files)
    {
        next if $file =~ /^\.\.?$/;
#       next unless $file =~ /\.fasta/;

        print $file;
    }

}

# sub list_files_draft
# Didn't you read the comments above this?

sub list_files_draft
{
    my @array = shift;
    my $dir = "/share/eisen-d2/amphora2/ncbi_draft";
    opendir my $dh, $dir or die "Couldn't open directory $dir: $!";

    my @files = readdir $dh;
#    print "@files\n";
    foreach my $file (@files)
    {
        next if $file =~ /^\.\.?$/;
#       next unless $file =~ /\.fasta/;
        print $file;
    }

}
