#!/usr/bin/perl -w
# Rename genome files as taxon code, make .fasta

@files = <*>;
foreach $files (@files)
{
	open (FILE, $files);
	read(FILE, $tax, 5);
	$_ = $tax;
	if (/>(\w+)|/) {
		$tax = $1;
	}
	print ($files);
	print ("\n");
	rename ($files, "$tax\.fasta");
	close (FILE);
}

exit;