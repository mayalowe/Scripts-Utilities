#! /usr/bin/perl 
# This is a perl script that takes an input file of seq data
# and produces a ~20Mb tutorial dataset for Phylosift.
# Ignores beginning and end of file and uses middle data
# because of better quality.

use warnings; use strict;

my $input = shift;         # Get input file from command line

open my $fh, "bzcat '$input' |" or die "Couldn't open [bzcat '$input']:$!";
my $i = 0;
while (my $line = <$fh>) {
    print $line if (int($i++ / 4)) % 10 == 0;
}
exit;
