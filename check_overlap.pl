#!/bin/perl
use strict;
use warnings;
my ($input, $tabfile) = @ARGV;

# take patman output as input. Check overlaps and only keep perfect matches

open (IN, $input) or die "can't open $!";
my $pos = 0; my $counter = 0; my $chr; my %hash;
while (<IN>) {
	$_ =~ /(\S+)\t(\S+)\t(\d+)\t(\d+)/;
	if (($3 <= $pos) and ($chr = $1)) {
		#chromosomes..
		exists ($hash{$counter}{$2}{$2});
	}
	else {
		$pos = $4;
		$counter ++;
		$chr = $1;
		exists ($hash{$counter}{$2}{$2});
	}
}

my $count = 0;
while ($count <= $counter) {
	my $newcount = 0;
	while ($newcount <= $counter) {
		if ( $count == $newcount ) {
			$newcount ++;
		}
		if ( exists ($hash{$count})) {
			if (exists ($hash{$newcount})) {
				foreach my $seq (keys %{$hash{$count}}) {
					if ( exists ($hash{$newcount}{$seq})) {
					}
					else {
						$newcount ++;
						last;
					}
					
					delete ($hash{$count});
				}
			}
			else {
				$newcount ++;
			}
		}
		else {
			$count ++;
			last;
		}
	}
	$count ++;
}

foreach my $key (keys %hash) {
}
$count = 0;
my %seqlist;
while ($count <= $counter) {
	if ( exists ($hash{$count})) {
		foreach my $key (keys %{$hash{$count}}) {
			push @{$seqlist{$key}}, $count;
		}
	}
	$count ++;
}
open (IN2, $tabfile) or die "can't open $!";
my %finalcounts;
while (<IN2>) {
	my @list = split(/\t/, $_);
	my $seq = shift(@list);
	if ( exists ($seqlist{$seq})) {
		#print ">$seq\n$seq\n";
		foreach (@{$seqlist{$seq}}) {
			my $name = $_;
			if ( exists ($finalcounts{$name})) {
				my $counter = 0;
				foreach my $value (@list) {
					if ($value > 0) {
						$finalcounts{$name}[$counter] = $value;
					}
					$counter++;
				}
			}
			else {
				@{$finalcounts{$name}} = @list;
			}
		}
	}
}
foreach my $key (keys %finalcounts) {
	print "$key\t";
	print "@{$finalcounts{$key}}";
}
