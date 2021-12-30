#!/bin/perl
#
# Compares an sRNA file to a database of previously described miRNA (miRBase)
# Identifies sequences which have been previously described
#
use strict;
use warnings;
my ($input, $miRBase, $output) = @ARGV;
open (IN, $input) or die "can't open $!";
my %pred;
while (<IN>) {
	if ($_ =~ /^>/) {
		my $seq = <IN>;
		chomp $seq;
		exists ($pred{$seq}{$seq});
	}
}
close IN;

open (OUT, ">>$output") or die "can't open $!";
open (IN, $miRBase) or die "can't open $!";
while (<IN>) {
	if ($_ =~ /^>(\D+\d+)/) {
		my $name = $1;
		my $seq = <IN>;
		chomp $seq;
		if (exists($pred{$seq})) {
			print OUT ">$name\n$seq\n";
		}
	}
}
