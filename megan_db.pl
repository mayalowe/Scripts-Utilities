#! /usr/bin/perl
# Author: Eric Lowe
# Usage: perl megan_db.pl [input file] [knockout file] [gi file]
# Script to create a custom db for MEGAN

use strict; use warnings;
use File::Fetch;
use File::stat;
use Time::localtime;

my $input = shift;
my $kofile = shift;
my $gifile = shift;

open my $fh, $input or die "Couldn't open file $input: $!";

# get an array with ko id's from subroutine
my @ko = get_koed($kofile);
print "$ko[2] is the third knockout id!\n"; #debugging statement

my $data = gi_from_taxid(\@ko, $gifile);

print "$$data->$ko[2] is the GI of the third knockout id!\n";
close $fh;
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
	print "$array[2] is the third knockout id!\n"; #debugging statement
	return @array;
}

# gi_from_taxid(\@ko, $gifile)
# sub gi_from_taxid takes a reference to the knockout array
# and a file with a list of GenBank ID's and Taxon IDs and
# finds the corresponding GenBank ID for each Taxon ID.

sub gi_from_taxid
{
	my $ko = shift;
	print "$$ko[2] is the third knockout id!\n"; # debugging statement
	
	my $gi = shift;
	open my $fh, $gi or die "Couldn't open GenBank ID file $gi: $!";
	
	my $stamp = ctime(stat($fh)->mtime);
	#print "$stamp\n";
	my %hash;
	
	while (<$fh>) 
	{
		my $line = $_;
		#print "$line\n";
		
		if ($line =~ /(\d+)\s+(\d+)/) 
		{
			#print "TaxID: $2 ; GI: $1\n";
			
			if (exists $hash{$2})
			{
				next;
			} else {
				$hash{$2} = $1;
			}
		}
	}
	
	close $fh;
	return \%hash;
}
    


