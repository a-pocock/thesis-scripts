#!/bin/perl

### This script takes a small RNA seed mapped to a degradome and the transcripts these degradome sequences come from
### It then maps the full small RNA sequence to the transcript using patman and confirms this spans the cleaved target
### Output first provides mapping details of the degradome to the transcriptome. 
### This is followed by tab-delimited information about this run beggining with the sRNA transcript.

use strict;
use warnings;
# add module Cwd so that modules are available in this directory
use Cwd;
use lib cwd;
# if File::Temp is not working from this directory add the line "use lib (.);"
use File::Temp qw(tempfile);

# get path to input and output files
my ($degradome_seed, $transcript_match, $output) = @ARGV;
# if patman will not run set the filepath here
my $filepath = "."; 

# make hash of sRNA which match to degradome targets using subroutine on line 74
my %degradome_hash = get_targets($degradome_seed);

open (TRANSCRIPT, $transcript_match) or die "can't open $!";
open (OUT, ">>$output") or die "Can't open $!";

# check sRNA which target degradome sequences also map to the transcript that the degradome sequence originated from
while (<TRANSCRIPT>) {
	# Get the degradome sequence identifier which matches a transcript and check an sRNA targets it
	if ($_ =~ /^>(\w+-\d+)/) {
		# deg_name contains extra information from earlier mapping of the degradome to the genome
		my $deg_name = $_;
		if (exists ($degradome_hash{$1})) {
			# make temp sRNA database (.fa format) and populate it with all sRNA which may target the degradome
			# these are taken from the degradome hash.
			# temporary files are created using the perl module File::Temp
			my $TEMPSRNA = File::Temp->new();
			foreach my $key (keys %{$degradome_hash{$1}}) {
				print $TEMPSRNA ">$key\n$key\n";
			}

			# make temp database of cleaved targets (.fa format) these are populated from the cleavage sites
			my $TEMPDB = File::Temp->new();
			# Transcript targets are .fa format and contain 20nt either side of the putative cleavage site
			my $cleavage_site = (<TRANSCRIPT>); 
			if ($cleavage_site !~ /^>/) {
				# $deg_name is used as it contains extra information on the degradome for downstream processing
				print $TEMPDB ">$deg_name\n$cleavage_site";

				# create a temporary output file for small RNA alignments
				my $TEMPOUT = File::Temp->new();
				# use the patman short sequence aligner with up to 4 mismatches across the sRNA sequence
				# $TEMPDB is the database and $TEMPSRNA is the pattern.
				system ("$filepath/patman -q -l 15 -e 4 -D $TEMPDB -P $TEMPSRNA -o $TEMPOUT");

				# locate the temporary output file and open it.
				seek $TEMPOUT, 0, 0 or die "Seek $TEMPOUT failed: $!\n";
				while (<$TEMPOUT>) {
					$_ =~ /\S+\t(\S+)\t(\d+)\t(\d+).*/;
 
				# Check that sRNA sequences align across the putative cleavage site in either orientation
					if (20 <= $2 && 20 >= $3 || 20 <= $3 && 20 >= $2) {
						# alignments which meet criteria are printed
						# output will include mapping information for the degradome sequence,
						# the sRNA and the results for this alignment.
						print OUT $_;
					}
				}
			}
		}
	}
}

# subroutine to take input degradome sRNA alignments and output a hash
# hash contains a degradome identifier as the key and the sRNA as their values.
# These sRNA values are stored as a key so that they are not created more than once
sub get_targets {
	my ($degradome_seed) = @_;
	open (DEG, $degradome_seed) or die "can't open $!";
	my %output_hash;
	while (<DEG>) {
		$_ =~ /(\S+)\t(\S+)/;
		# a check for the existence of a key within a key is used to create keys with no value.
		# this is useful as it avoids storing unnecessary data
		exists ($output_hash{$1}{$2}{$2});
	}
	return %output_hash;
	close DEG;
}
