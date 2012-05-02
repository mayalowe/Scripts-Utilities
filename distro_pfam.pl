#!/usr/bin/perl -w
# Author: elowe@ucdavis.edu
# Script name: distro_pfam.pl
#
# Command line syntax: ./distro_pfam.pl [filename]
#
# This script is designed to take input in the form of a .txt file,
# parse the file for pfams, identify associated protein seqs, 
# retrieve those protein seqs and put them into a new .fasta file
# with [filename] = pfam ID
#
use strict;
use Bio::SeqIO;

open(IN, "$ARGV[0]") or die "error reading $ARGV[0] for reading"; # Open input for reading, exit if error

my @lines = <IN>; # Store file contents in array so that lines can be parsed individually
chomp @lines;

my $lines;

foreach $lines (@lines) # foreach loop to parse each line of input file
{
    my ($pfamid, undef, undef) = split(/:/, $lines); # Assign pfam ID num to $pfamid (colon delimited)
    my @pfamprots = split(' ', $lines); # Assign protseq ID's to array @pfamprots (space delimited)

    chomp @pfamprots;
    shift @pfamprots; # Get rid of $pfamprots[0] since $pfamprots[0] = $pfamid

    my $pfamfile = "$pfamid.fasta";
    $pfamfile =~ s/halophile/PFam/g;

    print $pfamfile."\n";

#    my $seq_out = Bio::SeqIO->new(-file => ">>$pfamfile", -format => 'fasta');
    my $num_prots = scalar(@pfamprots); # Determine number of protein seqs in pfam 


    for (my $i = 0; $i < $num_prots; $i++)
    {
	my $prot_id = $pfamprots[$i];
	my @splitprot = split('\|', $pfamprots[$i]);
	my $org_id = $splitprot[0]; # Assign three letter organism code to $org_id
	my $infile = "/Users/Eric/Desktop/Lab/Haloarchaa/Fasta_files/$org_id\.fasta";
	my $inseq = Bio::SeqIO->new(-file => "<$infile", -format => 'fasta');

	while (my $seq = $inseq->next_seq)
	{
	    my $seq_id = $seq->id;
	    if ($seq_id =~ /$prot_id/)
	    {
#		$seq_out->write_seq($seq_id);
#		$seq_out->write_seq($seq);
		last;
	    }

	}
    }

}

close(IN);
exit;
