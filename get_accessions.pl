#!/bin/perl
use strict;
use warnings;
# short subroutine to make a list of miRBase accessions for plant groups.
# Group accessions are taken from a list of all miRBase accessions.

my ($accessions, $miRBase_seq) = @ARGV;
open (ACCESIONS, $accessions) or die "can't open $!";
my %phylum;
while (<ACCESIONS>) {
	if ($_ =~ /(\w+).+Viridiplantae;([^;]+)/) {
		$phylum{$1} = $2;
	}
}

open (MIRBASE, $miRBase_seq) or die "can't open $!";
my %miRBase;
my %groups;
while (<MIRBASE>) {
	my $name = $_;
	my $mirna = <MIRBASE>;
	chomp $mirna;
	if ($name =~ />(\w+)-(miR)(\d+)(\S*)/ && exists($phylum{$1})) {
		if ($3 >= 156 && $3 <= 408) {
			exists ($groups{"$2$3"}{$phylum{$1}}{$1});
			$miRBase{"$2$3"}{"$1-$2$3$4"} = $mirna;
		}
	}
}
my $minimum = 2;
foreach my $family (keys %groups) {
	my $count = keys %{$groups{$family}};
	#print $family;
	if ($count >= $minimum) {
		foreach my $name (keys %{$miRBase{$family}}) {
			print ">$name\n$miRBase{$family}{$name}\n";
		}
	}
}
