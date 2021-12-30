#!/bin/perl
use strict;
use warnings;

# generate a list of all mature miRNA from miRBase for all plant, monocot and wheat miRNA.
# accessions are taken from the miRBase file "organisms.txt"

open (IN, "organisms.txt") or die "can't open $!";

my (%plant, %monocot, %wheat);
while (<IN>) {
	$_ =~ /^(\S+)/;
	my $abbr = $1;
	if ($_ =~ /Viridiplantae/) {
		$plant{$abbr} = $abbr;
		if ($_ =~ /monocotyledons/) {
			$monocot{$abbr} = $abbr;
			if ($abbr eq "tae") {
				$wheat{$abbr} = $abbr;
			}
		}
	}
}

close IN;
open (PLANT, ">>plant_mature.fa") or die "can't open $!";
open (MONO, ">>monocot_mature.fa") or die "can't open $!";
open (WHEAT, ">>wheat_mature.fa") or die "can't open $!";

open (MIR, "mature.fa") or die "can't open $!";
while (<MIR>) {
	if ($_ =~ />(...)/) {
		my $name = $_;
		my $seq = <MIR>;
		if ( exists ($plant{$1})) {
			print PLANT "$name$seq";
			if ( exists ($monocot{$1})) {
				print MONO "$name$seq";
				if ( exists ($wheat{$1})) {
					print WHEAT "$name$seq";
				}
			}
		}
	}
}

