#!/bin/perl
#
use strict;
use warnings;

#create list of sequences and their counts from a number of files
#creates a csv file listing the sequence, total count and count for each file.
#
#filelist is created by piping ls of all fa files into a single file. eg "ls * > filelist"

my ($filelist, $col_combine, $outfile) = @ARGV;
open(LIST, "$filelist") or die "Couldn't read $!";
open(ALL, "$col_combine") or die "Couldn't read $!";

my %seqlist;

while (<ALL>) {
	if ($_ =~ /^>\d+-(\d+)/) {
		my $seq = <ALL>;
		chomp $seq;
		$seqlist{$seq} = [",$1"];
	}
}
my %header;
my $val = 0;
while (<LIST>) {
	$_ =~ /(\d+)/;# this is the file id
	my $filename = $_;
	push( @{ $header{seq} }, ",$1"); #append to make list
	foreach my $key (keys %seqlist) {
		open(SEQ, $filename) or die "Couldn't read $!";
		while (<SEQ>) {
			if ($_ =~ /^>\d+-(\d+)/) {
				my $seq = <SEQ>;
				chomp $seq;
				if ($key eq $seq) {
					$val = $1;
				}
			}
		}
		push( @{ $seqlist{$key} }, ",$val");
		$val = 0;
	}
}
open(OUT, ">>$outfile") or die "Can't open $!";
print OUT "seq,total","@{ $header{seq} }\n";
foreach my $key (keys %seqlist) {
	print OUT "$key";
	foreach ($seqlist{$key}) {
	print OUT "@{ $seqlist{$key} }\n"
	}
}
