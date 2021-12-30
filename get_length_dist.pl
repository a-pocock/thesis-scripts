#!/bin/perl
use strict;
use warnings;

#takes fasta file as input. Checks the length distribution and outputs
#the number of sequences for each different length.

my ($input) = @ARGV;
open (IN, $input) or die "can't open $!";
my %lengthdist;
my $maxlen = 0;
while (<IN>) {
	if ( $_ =~ />/ ) {
		my $seqcount = 1;
		if ($_ =~ />\w+-(\w+)/) {
			$seqcount = $1;
		}
		my $seq = <IN>;
		chomp $seq;
		my $len = length($seq);
		if ($len > $maxlen) {
			$maxlen = $len
		}
		if ( exists ( $lengthdist{$len} )) {
			$lengthdist{$len}=$lengthdist{$len} + $seqcount;
		}
		else {
			$lengthdist{$len} = $seqcount;
		}
	}
}

my $count = 0;
while ($count <= $maxlen) {
	if ( exists ( $lengthdist{$count} )) {
		print "$count\t$lengthdist{$count}\n";
	}
	else {
		print "$count\n";
	}
	$count ++;
}
