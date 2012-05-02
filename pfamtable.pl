#!usr/bin/perl
use warnings; use strict;

#A script for dealing with a nasty file that Eric exposed me to
#Since Eric's reading this, I'm going to go ahead and write comments that
#are useful and teach things about perl! Why the heyull nawt.

#FILE FORMAT: We're making a file formatted as follows:
#halophileXXX1: species1|1 species2|2 species1|3 species3|4...
#halophileXXX2: species1|5 species2|6 species1|7 species3|8...
#halophileXXX3: species1|9 species2|10 species1|11 species3|12...
#into a file formatted as follows:
#		species1	species2	species3
#	XXX1   1			0			1
#	XXX2   1			1			0
#	XXX3   0			1			1
#where 1/0 are true/false for if a protein is in that species & pfam, and species1,2,...n are the 3 letter species codes

#Part 1: Getting a list of the 3-letter species headers for further organization
my @species = speciesnames(); #Phew, that was easy! One liner!

#Part 2: Using that list to organize a species-pfam-protein table
#Plan: Read through each pfam for each different species header, then 
#grab the protein name and add it into a hash for each species where 
#the hash is like this:
#one hash per pfam, then keys = "Species" & value = "protein1,protein2,protein3".
#then write it into the file on that same iteration.

my $file = "groups.txt"; #the file name Eric gave me								#NOTE TO READER:
open (IN, "<$file") or die "Couldn't open ridiculous file $file\n"; 				#For convenience I'm making this code
open (OUT, ">output.txt") or die "Couldn't open output file\n"; 					#print lots of stuff for debugging/
#Hash for storage of species information as per plan								#sense-making purposes.								
my %pfam_species;

#MAKING THE FILE:	
#A: First write in the top 'header' to the OUT file, since we already know our species
for (my $i = 0; $i<scalar(@species); $i++) {
	print OUT "\t$species[$i]";
}		
print OUT "\n"; #move on to the next line

#B: Now, write in each line						
while (<IN>) {																		
	#Step 1: Split the line to be able to get species|protein lines on their own
    my $line = $_; #note, arrays here are named by iterations of splits - @partsn
    my @specproteins = split(" ",$line); #split the line by spaces - get each piece of info on its own
    #substep: need to get the correct pfam number for the list
    my $halophile = "pfam".substr($specproteins[0],9); #this is just the halophile number in the nth line
    print "Working on $halophile now\n";
    print OUT $halophile; #this starts a line in the file
    shift @specproteins; #this removes the 0th index in the array, 'halophileXXXX', so we can use the array otherwise
   
    #Step 2: Going through each species|protein to check which species it belongs to.
    for (my $i = 0; $i<scalar(@species); $i++) { #For each species...
    	print "Now looking at $species[$i]...\n";
    	my $proteins = 0; #define a string for all the protein names, which will be separated by commas
    	for (my $j = 0; $j<scalar(@specproteins); $j++) { #For each line in the species-protein data…
    		if ($species[$i] =~ $specproteins[$j]) { #if there's a match
    			my $protID = substr($specproteins[$j],4);
    			print "$protID matches $species[$i]!\n";
    			
    			#Two options here: Either adding the protein IDs or just doing a true/false
    			#Option 1:
    			#$proteins = $protID.",".$proteins; #add it to this proteins string
    			#Option 2
    			$proteins = 1; #1 is our binary 'true' value, 0 is 'false'
    		}
    		else {next;} #otherwise set it to 'false' move on

    	}
    	#After you've made this $proteins string, make a hash as described in plan above
    	$pfam_species{$species[$i]} = $proteins; 
    } 
    
    #Step 3: Once you've made a hash per pfam, write it into a file
    print "Adding information for $halophile into the file!\n";
    for (my $k = 0; $k<scalar(@species); $k++) {
    	print OUT "\t$pfam_species{$species[$k]}";
    	}
	print OUT "\n";    	
}

#Et voila!

                           #`-:_                          
  #----....____            |    `+.                              
 #             ````----....|___   |                               
  #     _                      ````----....____                   
   #    _)             SUBROUTINES              ```---.._          
    #                                                    \         
  #`.\  )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.      
#'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `

#Speciesname grabs a list of species names and delivers them as an array, for iteration in later subs.
sub speciesnames {
	my $file = "groups.txt"; #the file name Eric gave me
	open (FILE, "<$file") or die "Couldn't open ridiculous file $file\n"; 	#SIDEBAR ON DIE STATEMENTS...
	#For storage of species information										#They tell the program to stop if something goes wrong
	my %species;															#and to give you a preset error message. They're a good
	my @species;															#habit to get into, so your program doesn't get stuck
	while (<FILE>) {														#trying to read a file it hasn't opened, etc.
    	if ($_ =~ "halophile") {
        	#Step 1: Split the line iteratively to get the 3 letter species headers
        	my $line = $_; #note, arrays here are named by iterations of splits - @partsn
        	my @parts0 = split(" ",$line); 
        	for (my $i = 0; $i<scalar(@parts0); $i++) {
    	        shift @parts0; #this removes the 0th index in the array, which here is just 'halophile'
    	        print "Part $i $parts0[$i]\n"; #print line to make sure things are going ok
    	    #Step 2: Iteratively grab the species names from the lines, and add them to a hash
    	        for (my $j = 0; $j<scalar(@parts0); $j++) {
    	            my $speciesname = substr($parts0[$j],0,3); #SUBSTRING - format is substr($string,start index,length)
    	            $species{$speciesname}++; #this ends up storing the # of total proteins just in case! :)
    	        }
    	    }
    	}
	}
	#This defines an array to store those species names
	@species = keys %species;
	return @species; #returns the array of species names
}