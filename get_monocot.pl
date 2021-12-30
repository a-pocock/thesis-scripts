#!/bin/perl
use strict;
use warnings;

# take organisms from miRBase and find accessions for monocots
# output all miRNA or hairpins with accessions
# similar to 'get_accessions.pl' but just takes monocot miRNA

my ($miRBase) = @ARGV;
open (IN, "organisms.txt") or die "can't open $!";
my %accessions;
while (<IN>) {
	if ($_ =~ /monocotyledons/) {
		$_ =~ /(\S+)/;
		$accessions{$1}=$1;
	}
}
open (MIR, "$miRBase");
my $acc;
while (<MIR>) {
	if ($_ =~ />(...)/) {
		$acc = $1;
		if (exists ($accessions{$acc})) {
			print $_;
		}
	}
	elsif (exists ($accessions{$acc})) {
		print $_;
	}
}

