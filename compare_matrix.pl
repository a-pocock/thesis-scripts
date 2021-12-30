#!/bin/perl
#
#Generate a matrix to show the position of an miRNA precursor and the position of its target
#This is to determine if precursors from the A, B or D genome preference targets from the same genome.
#
use strict;
use warnings;
my ($precursor, $target) = @ARGV;
open (PRE,$precursor) or die "can't open $!";
open (TAR, $target) or die "can't open $!";
my %miRNA;
while (<TAR>) {
	if ($_ =~ /(\w+),\d(\w)/) {
		push @{$miRNA{$1}}, $2;
	}
}
my %matrix;
while (<PRE>) {
	if ($_ =~ /(\w+),\d(\w)/) {
		if (exists($miRNA{$1})) {
			foreach my $val (@{$miRNA{$1}}) {
				$matrix{$2}{$val}++;
			}
		}
	}
}
print "precursor genome, target\n,A,B,D\nA,$matrix{A}{A}, $matrix{A}{B}, $matrix{A}{D}\nB,$matrix{B}{A},$matrix{B}{B},$matrix{B}{D}\nD,$matrix{D}{A},$matrix{D}{B},$matrix{D}{D}\n\n";

