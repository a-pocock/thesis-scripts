#!/bin/perl
use strict;
use warnings;

# take file containing predicted miRNA and the coordinates of their degradome targets
# output a bed file which contains the coordinates of where miRNA map to their targets
my ($input) = @ARGV;

open (IN, $input) or die "can't open $!";
while (<IN>) {
	$_ =~ /(\S+)\t(\d+)\t(\d+)\t(\w+)\t.\t(.)\t\S+\t(\d+)\t(\d+)/;
	if ($5 eq "+") {
		my $end = $2 + $6; my $mirlen = length($4); my $start = $end - $mirlen;
		print "$1\t$start\t$end\t$4\t0\t-\n";
	}
	elsif ($5 eq "-") {
		my $start = $3 - $6; my $mirlen = length($4); my $end = $start + $mirlen;
		print "$1\t$start\t$end\t$4\t0\t+\n";
	}
}
