#!/bin/perl
use strict;
use warnings;

# script to take two input datasets in fasta format and only output sequences listed in both datasets

my ($input, $input2) = @ARGV;
open (IN, $input) or die "can't open $!";
my %sequences;
while (<IN>) {
	if ($_ =~ />/) {
	}
	else {
		my $seq = $_;
		chomp $seq;
		$sequences{$seq} = 1;
	}
}
open (FILE, $input2) or die "can't open $!";
while (<FILE>) {
	if ($_ =~ /(?:\S+\t){3}(\w+)/) {
	#	if ($_ =~ /(?:\S+\t){5}(\w+)/) {
		if (exists ($sequences{$1})) {
			print "$_";
		}
	}
}
