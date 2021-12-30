#!/bin/perl
use strict;
use warnings;
#get hairpin header and sequence for final miRNA predictions
my ($input, $hairpin, $output) = @ARGV;
my %names;
open (IN, $input) or die "can't open $!";
while (<IN>) {
	$_ =~ /(.*)/;
	my $header = $1;
	chomp $header;
	my $count = $1;
	$names{$header} = $count;
}
close IN;
open (HAIR, $hairpin) or die "can't open $!";
while (<HAIR>) {
	if ($_ =~ />(.*)/) {
		if ( exists($names{$1})) {
			print ">$names{$1}\n";
			my $seq = <HAIR>;
			print "$seq";
		}
	}
}

