#! /usr/bin/perl
# This is a perl script that takes an input file of seq data
# and produces a ~20Mb tutorial dataset for Phylosift.
# Ignores beginning and end of file and uses middle data
# because of better quality.

use warnings; use strict;

my $input_file = shift;         # Get input file from command line
#print "File: $input_file\n";
$input_file =~ m/\w+.(\w+)/;    # Get file format (stored in $1)
#print "Format: $1\n";
my $format = $1;                # Store file format in more portable variable
my $file_size = (-s $input_file) / (1024 * 1024);

print "File size: $file_size\n";

my $lines = `wc -l $input_file`;
$lines =~ s/\s+\w+.\w+//;
print "Number of lines: $lines\n";

my $front_cut = 0.05 * ($lines / 4);
print "Cut from front: $front_cut\n";
exit;
