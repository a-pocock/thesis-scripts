#!/bin/perl
use strict;
use warnings;

# there is use for some distinction between the a, b and d genomes
# this script reads bedfiles and splits predictions into a,b or d genomes
# output as fasta file with input line as the header

my ($input) = @ARGV;
open (IN, $input) or die "can't open $!";
open (OUTA, ">>chrA.fa") or die "can't open $!";
open (OUTB, ">>chrB.fa") or die "can't open $!";
open (OUTD, ">>chrD.fa") or die "can't open $!";

while (<IN>) {
	if ($_ =~ /chr.A\S+\t\d+\t\d+\t(\w+)/) {
		print OUTA ">$_$1\n";
	}
	elsif ($_ =~ /chr.B\S+\t\d+\t\d+\t(\w+)/) {
		print OUTB ">$_$1\n";
	}
	elsif ($_ =~ /chr.D\S+\t\d+\t\d+\t(\w+)/) {
		print OUTD ">$_$1\n";
	}
}
