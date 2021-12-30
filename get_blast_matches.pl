#!/bin/perl
#
use strict;
use warnings;
# read through blast output and summarise the best target for each gene and place into a csv file format
my ($input) = @ARGV;
open (IN, $input) or die "can't read $!";
while (<IN>) {
	if ($_ =~ /(Traes\S+)/) {
	# the Traes header is specific to this data, will need to update if using a different genome
		print "$1,";
		OUTERLOOP: while (<IN>) {
			if ($_ =~ /^LOC_Os/) {
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
