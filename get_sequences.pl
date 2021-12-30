#!/bin/perl;
use strict;
use warnings;

my ($intersect_bed, $mffe) = @ARGV;
open (BED, $intersect_bed) or die "can't open $!";
my %names;
my %miRNA;
while (<BED>) {
	if ($_ =~ /(\S+)\t(\d+)\t(\d+)\t(\w+)\t.\t(.)/) {
		$names{">$1:$2-$3($5)"} = $4;
	}
}
open (FFE, $mffe) or die "can't open $!";
while (<FFE>) {
	if ($_ =~ /(\S+)\t(\S+)\t(\S+)/) {
		if ( exists ( $names{$1})) {
			if ( exists ($miRNA{$names{$1}})) {
				if ($miRNA{$names{$1}}[0] > $2) {
					$miRNA{$names{$1}} = [$2, $3, $1];
				}
				elsif (($miRNA{$names{$1}}[0] == $2) and ($miRNA{$names{$1}}[1] < $3)) {
					$miRNA{$names{$1}} = [$2, $3, $1];
				}
			}
			else {
				$miRNA{$names{$1}} = [$2, $3, $1];
			}
		}
	}
}

foreach my $key (keys %miRNA) {
	print "$key\t$miRNA{$key}[0]\t$miRNA{$key}[1]\t$miRNA{$key}[2]\n";
}

			
