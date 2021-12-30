#!/bin/perl
use strict;
use warnings;

# Takes Two fasta files and output sequences shared between the two files
#
my ($bfmir, $deg, $intersect) = @ARGV;

open (BFMIR, $bfmir) or die "can't open $!";
my %mir;

while (<BFMIR>) {
	if ($_ =~ /^>/) {
		my $name = $_;
		my $seq = <BFMIR>;
		$mir{$seq}{$name} = $name;
	}
}
close BFMIR;

open (OUT, ">>$intersect") or die "ccan't open";
open (DEG, $deg) or die "Can't open $!";
while (<DEG>) {
	if ($_ =~ /^>/) {
		my $name = $_;
		chomp $name;
		my $seq = <DEG>;
		if (exists ($mir{$seq})) {
			foreach my $precursor (keys %{$mir{$seq}}) {
				print OUT "$name","_$precursor","$seq";
#				print OUT "$name","$precursor","_$mir{$seq}$seq";
			}
		}
	}
}
