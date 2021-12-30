#!/bin/perl
use strict;
use warnings;

#Mapping bowtie against rice genome contains annotations for rice genes. 
#This script takes the best match for each aligned sequence and outputs
#the annotations for that target.

my ($in, $annot) = @ARGV;
open (IN, $in) or die "can't open $!";
my %hash;
while (<IN>) {
	if ($_ =~ /previous_id=(Traes\S+?);/) {
		$hash{$1} = $_;
	}
}

open (ANN, $annot) or die "can't open $!";
while (<ANN>) {
	if ($_ =~ /(Traes\S+?)\./) {
		if (exists($hash{$1})) {
			print $_;
		}
	}
}
