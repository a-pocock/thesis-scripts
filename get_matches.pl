#!/bin/perl
#
use strict;
use warnings;
# read through blast output and summarise the best target for each gene and place in .csv file
my ($input) = @ARGV;
open (IN, $input) or die "can't read $!";
while (<IN>) {
	if ($_ =~ /(Traes\S+)/) {
		print "$1,";
		OUTERLOOP: while (<IN>) {
			if ($_ =~ /^AT\dG/) {
				my $value = $_;
				chomp $value;
				print "$value,";
				while (<IN>) { 
					if ($_ =~ /Identities/) {
						print "$_";
						last OUTERLOOP;
					}
				}
			}
		}
	}
}
