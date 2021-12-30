#!/bin/perl

use strict;
use warnings;

# This script takes a list of input files, creates a list of all sequences.
# Sequences in the miRBase database are output as a table with the counts from all files
# Families in miRBase are output as a table with counts for all files

my ($input) = @ARGV;
my $count;
open (IN, $input) or die "can't open $!";
my (%sequence, %mirbase);
while (<IN>) {
	my @superlist = $_ =~ /(\S+)/g;
	my $key = shift @superlist;
	$count = 0;
	foreach (@superlist) {
		my @sublist = $_ =~ /(miR\d+)/g;
		foreach (@sublist) {
			$sequence{$key}{$count}{$_} = $_;
			$mirbase{$_}{$count}{$key} = $_;
		}
	$count ++;
	}
}
open (OUTMIR, ">>miRBase_alignments.txt") or die "can't open $!";
open (OUTFAM, ">>miRBase_family_alignments.txt") or die "can't open $!";
my @totalmiRBase = (0) x 33;
my @total_families = (0) x 33;
foreach my $key (keys %sequence) {
	my $counter = 0;
	print OUTMIR "$key";
	while ($counter < $count) {
		my @array;
		if (exists ($sequence{$key}{$counter})) {
			print OUTMIR "\t1";
			$totalmiRBase[$counter] = $totalmiRBase[$counter] + 1;
		}
		else {
			print OUTMIR "\t0";
		}
	$counter ++;
	}
	print OUTMIR "\n";
}
my $total_count = keys %sequence;
print "total_miRBase_matches_=$total_count";
foreach (@totalmiRBase) {
	print "\t$_"
}

foreach my $key (keys %mirbase) {
	my $counter = 0;
	print OUTFAM "$key";
	while ($counter < $count) {
		if (exists ($mirbase{$key}{$counter}) ) {
			print OUTFAM "\t1";
			$total_families[$counter] = $total_families[$counter] + 1;
		}
		else {
			print OUTFAM "\t0";
		}
	$counter ++;
	}
	print OUTFAM "\n";
}	
my $family_count = keys %mirbase;
print "\nTotal_families_=$family_count";
foreach (@total_families){
print "\t$_";
}
