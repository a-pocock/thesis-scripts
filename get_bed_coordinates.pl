#!/bin/perl
use strict;
use warnings;

# use this script to get the coordinates for a number of miRNA listed in a bedfile

my ($miRNA, $bedfile) = @ARGV;
my %seq;
open (MIR, $miRNA) or die "can't open $!";
while (<MIR>) {
	if ($_ =~ />/) {
	}
	elsif ($_ =~ /(\w+)/) {
		$seq{$1} = 1;
	}
}

open (BED, $bedfile) or die "can't open $!";
while (<BED>) {
	if ($_ =~ /\S+\t\S+\t\S+\t(\w+)/) {
		if ( exists ($seq{$1})) {
			print $_;
		}
	}
}
