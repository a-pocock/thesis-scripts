#!/bin/perl
#
use strict;
use warnings;

# Take an input file, list sequences and check against known miRNA in miRBase
# Output previously identified miRNA and name using their family names.

my ($input, $miRBase, $output) = @ARGV;

open (IN, $input) or die "can't open $!";
my %values;
while (<IN>) {
	my $seqs = $_;
	chomp $seqs;
	my @line = split("\t", $seqs);
	my $seq = shift(@line);
	$values{$seq} = [@line];
}

my %families;
open (IN, $miRBase) or die "can't open $!";
while (<IN>) {
	if ($_ =~ /^>(\D+\d+)/) {
		my $name = $1;
		my $line = <IN>;
		$line =~ /([ATCG]+)/; 
		my $seq = $1;
		if (exists($values{$seq})) {
			if (exists($families{$name})) {
				my $count = 0;
				foreach (@{$values{$seq}}) {
					if ($_ == 1) {
						$families{$name}[$count] = 1;
					}
					$count++;
				}
			}
			else {
				$families{$name} = [@{$values{$seq}}];
			}
		}
	}
}

open (OUT, ">>$output") or die "can't open $!";
foreach my $key (keys %families) {
	print OUT "$key";
	foreach (@{$families{$key}}) {
		print OUT "\t$_";
	}
	print OUT "\n";
}
