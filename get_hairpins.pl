#!/bin/perl
#
#Take predicted hairpin coordinates from an alignment
#Output these sequences as a fasta file
#
use strict;
use warnings;

my ($sRNA, $hairpin_predictions, $output, $genome) = @ARGV;
open (IN, $sRNA) or die "can't open $!";
my %predictions;
while (<IN>) {
	if ($_ =~ /^>/) {
		my $seq = <IN>;
		chomp $seq;
		exists($predictions{$seq}{$seq});
	}
}
close IN;
open (IN, $hairpin_predictions) or die "can't open $!";
open (OUT, ">>$output") or die "can't open $!";
while (<IN>) {
	if ($_ =~ /^(\S+)\t(\S+)\t(\S+)\t(\S+)\t(\S+)\t(\S+)\t(\S+)/) {
		if (exists($predictions{$1})) {
			print OUT "$2\t$5\t$6\t$1\t$7\n";
		}
	}
}

system "bedtools getfasta -fi $genome -bed $output -name -s > $output.fasta";
