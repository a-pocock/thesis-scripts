#!/bin/perl
use strict;
use warnings;

# script to convert predicted target coodinates to genome coordinates
#
my ($input, $output) = @ARGV;
open (IN, $input) or die "can't open $!";
open (OUT, ">>$output") or die "can't open $!";

while (<IN>) {
	if ($_ =~ /part1/) { my $val = 0 }
	if ($_ =~ /chr1A_part2/) { my $val = 471304005 }
	if ($_ =~ /chr1B_part2/) { my $val = 438720154 }
	if ($_ =~ /chr1D_part2/) { my $val = 452179604 }
	if ($_ =~ /chr2A_part2/) { my $val = 462376173 }
	if ($_ =~ /chr2B_part2/) { my $val = 453218924 }
	if ($_ =~ /chr2D_part2/) { my $val = 462216879 }
	if ($_ =~ /chr3A_part2/) { my $val = 454103970 }
	if ($_ =~ /chr3B_part2/) { my $val = 448155269 }
	if ($_ =~ /chr3D_part2/) { my $val = 476235359 }

	if ($_ =~ /chr4A_part2/) { my $val = 452555092 }
	if ($_ =~ /chr4B_part2/) { my $val = 451014251 }
	if ($_ =~ /chr4D_part2/) { my $val = 451004620 }
	if ($_ =~ /chr5A_part2/) { my $val = 453230519 }
	if ($_ =~ /chr5B_part2/) { my $val = 451372872 }
	if ($_ =~ /chr5D_part2/) { my $val = 451901030 }

	if ($_ =~ /chr6A_part2/) { my $val = 452440856 }
	if ($_ =~ /chr6B_part2/) { my $val = 452077197 }
	if ($_ =~ /chr6D_part2/) { my $val = 450509124 }
	if ($_ =~ /chr7A_part2/) { my $val = 450046986 }
	if ($_ =~ /chr7B_part2/) { my $val = 453822637 }
	if ($_ =~ /chr7D_part2/) { my $val = 453812268 }

	if ($_ =~ /chrUn/) { my $val = 0 }
	
	$_ =~ /(\S+)\t(\S+)\t(\S+)\t(\d+)\t(\d+)\t(.*)/;

