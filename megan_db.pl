#! /usr/bin/perl
# Author: Eric Lowe
# Script to create a custom db for MEGAN

use strict; use warnings;

my $input = shift;
my $kofile = shift;

open my $fh, $input or die "Couldn't open file $input: $!";


sub get_koed
{
    my $in = shift;
    


