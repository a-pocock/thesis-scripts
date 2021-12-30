#!/bin/perl
use strict;
use warnings;

# read input from miRBase, find unique sequences from each family
# output a list of non-redundant miRNA named using their family

my ($input) = @ARGV;
open (IN, $input) or die "can't open $!";
my %famlist;
while (<IN>) {
	if ($_ =~ /(miR\d+)/) {
		#		my $name = ">$1";
		my $name = "$1";
		my $seq = (<IN>);
		$famlist{$name}{$seq}=$seq;
	}
}

foreach my $name (keys %famlist) {
	print "$name\n";
	foreach my $seq (keys %{$famlist{$name}}) {
		#		print "$name\n$seq";
	}
}
