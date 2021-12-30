#!/bin/perl
#
use strict;
use warnings;
#
# Takes a combined file where sequences have been named using prediction programs.
# Converts this data into a binomial table where if a program has predicted a sequence it gets value of 1.
#
my ($input) = @ARGV;
open (IN, $input) or die "can't open $!";
my $outfile = "output_summary2";
open (OUT,">>$outfile") or die "can't open $!";
while (<IN>) {
	$_ =~ /(\S+)/;
	my $name = $1;
	#	print OUT "$name\t";
	if ($_ =~ /mirbase_ath-(MIR\d+)/) {
		print OUT "$1\t1\t";
	}
	else { print OUT "0\t0\t";}
	if ($_ =~ /(mircat\S+)/) { print OUT "1\t" }
	else {print OUT "0\t"}
	if ($_ =~ /(mireap\S+)/) { print OUT "1\t" }
        else {print OUT "0\t"}
	if ($_ =~ /(miRDeep2\S+)/) { print OUT "1\t" }
        else {print OUT "0\t"}
	if ($_ =~ /(miRPlant\S+)/) { print OUT "1\t" }
        else {print OUT "0\t"}
	if ($_ =~ /(shortstack\S+)/) { print OUT "1\t" }
        else {print OUT "0\t"}
	if ($_ =~ /(miRanalyzer\S+)/) { print OUT "1\n" }
        else {print OUT "0\n"}
}	
