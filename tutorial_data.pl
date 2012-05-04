#! /usr/bin/perl
# tutorial_data.pl 
# This is a perl script that takes an input file of seq data
# and produces a ~20Mb tutorial dataset for Phylosift.
# Ignores beginning and end of file and uses middle data
# because of better quality.
# Usage: perl tutorial_data.pl [input file] > [output file]
use warnings; use strict;

# Get input file from command line
my $input = shift;        
# Open bzipped file as decompressed stream into filehandle $fh for reading
open my $fh, "bzcat '$input' |" or die "Couldn't open [bzcat '$input']:$!";  

my $i = 0; # Counting variable
while (my $line = <$fh>) {
    # Print line if remainder of $i / 4 equals 0
    print $line if (int($i++ / 4)) % 100 == 0;
}
exit;
