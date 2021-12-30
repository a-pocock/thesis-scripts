#!/bin/perl
use strict;
use warnings;
#
#Takes names of wheat proteins and outputs these proteins from a database.
#
my ($in, $protein) = @ARGV;
open (IN, $in) or die "can't open $!";
my %hash;
while (<IN>) {
	if ($_ =~ /ID=(Traes\S+?);/) {
		$hash{$1} = $_;
	}
}

open (PROT, $protein) or die "can't open $!";
my $geneid;
while (<PROT>) {
	if ($_ =~ />(Traes\S+?)\./) {
		$geneid = $1;
		if (exists($hash{$1})) {
			print $_;
		}
	}
	elsif (exists($hash{$1})) {
		print $_;
	}
}
