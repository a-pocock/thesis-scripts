#!/bin/perl
#
use strict;
use warnings;

my ($input, $sRNA, $output) = @ARGV;

open (IN, $input) or die "Can't open miRNA: $!";
my %mirna;
while (<IN>) {
	if ($_ =~ /^>/) {
		my $name = $_;
		my $seq = <IN>;
		$mirna{$seq} = $name;
	}
}

open (SRNA, $sRNA) or die "Can't open sRNA: $!";
open (OUT, ">>$output") or die "Can't open out: $!";

while (<SRNA>) {
	if ($_ =~ /^>/) {
		my $name = $_;
		my $seq = <SRNA>;
		if (exists($mirna{$seq})) {
			print OUT "$name", "$seq";
		}
	}
}
