#!/bin/perl
use strict;
use warnings;

# this script takes the specific cleavage sites and matches them to the input files to determine
# where the cleavage site is taken from.
#
my ($targets, $miRcurio_out) = @ARGV;

open (IN, $targets) or die "can't open $!";
my %chr;
while (<IN>) {
	if ($_ =~ /(\S+)\t(\d+)\t(\d+)\t(\w+)\t0\t(.)/) {
		if ($5 eq "-") {
			$chr{$1}{$2}{"-"}{$4} = 0;
		}
		elsif ($5 eq "+") {
			$chr{$1}{$3}{"+"}{$4} = 0;
		}
	}
}

open (TAR, $miRcurio_out) or die "can't open $!";
while (<TAR>) {
	if ($_ =~ /(\S+)\t(\d+)\t(\d+)\t(\w+)\t0\t(.)/) {
		if ($5 eq "-") {
			if (exists ( $chr{$1}{$3}{"-"}{$4} )) {
				print "$_";
			}
		}
		elsif ($5 eq "+") {
			if (exists ( $chr{$1}{$2}{"+"}{$4} )) {
				print "$_";
			}
		}
	}
}
