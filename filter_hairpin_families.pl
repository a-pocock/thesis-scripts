#!/bin/perl
#
use strict;
use warnings;

# take hairpins for known miRNA and filter based on families.

my ($input) = @ARGV;
open (IN, $input) or die "can't open $!";

my %hash;
while (<IN>) {
	my $line = $_;
	chomp $line;
	my @list = split(/\t/, $line);
	my $name = shift @list;
	if (exists($hash{$name})) {
		my $count = 0;
		foreach (@list) {
			if ($_ == 1) {
				$hash{$name}[$count] = 1;
			}
			$count++;
		}
	}
	else {
		$hash{$name} = [@list];
	}
}

foreach my $key (keys %hash) {
	print "$key";
	foreach (@{$hash{$key}}) {
		print "\t$_";
	}
	print "\n";
}
		
