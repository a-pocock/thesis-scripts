#!/bin/perl
#
use strict;
use warnings;
#
# Takes an fasta file of miRNA and matches them to miRBase sequences, where match occurs adds miRBase data
#
my ($input, $miRBase) = @ARGV;
open (IN, $input) or die "can't open $!";
my %miRNA;
while (<IN>) {
	my @line = split ("\t", $_);
	my $seq = shift @line;
	$miRNA{$seq} = \@line;
}
my %families;
open (MIR, $miRBase) or die "can't open $!";
while (<MIR>) {
	if ($_ =~ /^>([^\d]+\d+)/) {
		my $mirfam = $1;
		my $seq = <MIR>;
		chomp $seq;
		if (exists $miRNA{$seq}) {
			if (exists $families{$mirfam}) {
				my $count = 0;
				foreach (@{$miRNA{$seq}}) {
					if ($_ == 1) {
						$families{$mirfam}[$count] = $_;
					}
					$count++;
				}
			}
			else {
				$families{$mirfam} = $miRNA{$seq};
			}
		}
	}
}

foreach my $key (keys %families) {
	print "$key";
	foreach (@{$families{$key}}) {
		print "\t$_";
	}
}
