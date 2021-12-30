#!/bin/perl
use strict;
use warnings;
# script to take input fasta file and get the abundances for each sequence from a number of fasta files
# get input miRNA file
my ($miRNA, $filelist) = @ARGV;

# get names and number of sRNA files
# populate an array with filenames and a second with empty values.
open (FILES, $filelist) or die "can't open $!";
my @filenames; my @empty = (0);
while (<FILES>) {
	my $name = $_;
	chomp $name;
	push @filenames, $name;
	push @empty, 0;
}
# open miRNA file, create hash of miRNA of interest. Append a list of 0 counts for each library
open (MIR, $miRNA) or die "can't open $!";
my %MIRNA;
while (<MIR>) {
	if ($_ =~ />(\w+)/) {
		my $seq = (<MIR>);
		chomp $seq;
		# create key for miRNA sequence and list of empty counts
		$MIRNA{$seq} = [@empty];
	}
}

# take list of filenames to check against miRNA
# if miRNA within list add the number to the list. Each value also has a 0 value. 
# This is for the total count and all values are added to this.
my $count = 0;
print "miRNA\tall";
foreach my $file (@filenames) {
	$count++;
	get_targets ($file, $count);
	print "\t$file";
}
print "\n";

foreach my $key (keys %MIRNA) {
	print "$key";
	foreach my $val (@{$MIRNA{$key}}) {
		print "\t$val";
	}
	print "\n";
}

#create subroutine to read each file in file list

sub get_targets {
	my ($input, $num) = @_;
	open (IN, $input) or die "can't open $!";
	while (<IN>) {
		if ($_ =~ />(\w+)-(\d+)/) {
			if ( exists ( $MIRNA{$1})) {
				$MIRNA{$1}[$num] = $2;
				$MIRNA{$1}[0] = $MIRNA{$1}[0] + $2;
			}
		}
	}
}
