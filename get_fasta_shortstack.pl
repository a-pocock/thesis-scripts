#!/bin/perl
#
use strict;
use warnings;

#output from shortstack does not provide miRNA and hairpin in fasta format
#this script will take shortstack result file (result.txt)
#and generate a hairpin and mature miRNA fasta file
my ($input, $name) = @ARGV;
open (IN, $input) or die "can't open $!";
open (MIR, ">>$name\_miRNA.fa") or die "can't open $!";
open (HAIR, ">>$name\_hairpin.fa") or die "can't open $!";
while (<IN>) {
	if ($_ =~ /\S+\t(\S+)(?:\t\S+){6}\t(\S+)(?:\t\S+){3}\tY/) {
		print MIR ">$1\n$2\n";
		open (PRE, "MIRNAs/$1_Y.txt") or die "can't open $!";
		while (my $line =<PRE>) {
			if ($. == 3) {
				print HAIR ">$1\n$line";
			}
		}
		close PRE;
	}
}

