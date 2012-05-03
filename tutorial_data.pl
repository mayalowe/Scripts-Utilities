#! /usr/bin/perl 
# This is a perl script that takes an input file of seq data
# and produces a ~20Mb tutorial dataset for Phylosift.
# Ignores beginning and end of file and uses middle data
# because of better quality.

use warnings; use strict;

my $input_file = shift;         # Get input file from command line

open (IN, "bzcat $input_file") or die "What are you trying to do?";
my $i = 0;
while (my $line = <IN>) {
    print $line if (int($i++ / 4)) % 10 == 0;
}
exit;
