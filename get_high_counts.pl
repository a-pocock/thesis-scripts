#!/bin/perl
use strict;
use warnings;

# go through putative targets select the most abundant miRNA 
# targeting the most abundant degradome sequence.
#
# first get list of mature miRNA, use second file to get their abundance.
# check the targeting of miRNA to degradome sequences and for each target position
# select targets for the most abundant miRNA
# where miRNA are equally abundant select the target for the most abundant degradome sequence.
# 
my ($miRNA, $seq_counts, $targets) = @ARGV;

# open the input miRNA file read it into a dictionary 'mirseq'

open (MIR, $miRNA) or die "can't open $!";
my %mirseq;
while (<MIR>) {
	if ($_ =~ />(\w+)/) {
		exists ($mirseq{$1}{$1});
	}
}

close MIR;

# open the sRNA file check for corresponding miRNA and add sRNA count to dictionary

open (SRNA, $seq_counts) or die "can't open $!";
my $count;
while (<SRNA>) {
	if ($_ =~ />\d+-(\d+)/) {
		$count = $1;
	}
	elsif ($_ =~ /(\w+)/) {
		if ( exists ( $mirseq{$1})) {
			$mirseq{$1} = $count;
		}
	}
}

# open target file. Check abundance of degradome targets against miRNA counts
# output the most abundant degradome target for each miRNA
# where multiple miRNA target the same degradome sequence only the most abundant miRNA will be shown

open (TARGET, $targets) or die "can't open $!";
my ($stop, $miRNAcount, $degcount, $line, $chromosome) = 0,0,0,0,0;
while (<TARGET>) {
	if ($_ =~ /^(\S+)\t(\d+)\t(\d+)\t(\w+)\t\d+\t.\t[^-]+-(\d+)/) {
		if (exists ($mirseq{$4})) {
			if ($1 eq $chromosome) {
				if ($2 <= $stop) {
				#				if ($mirseq{$4} > $miRNAcount) {
					if ($degcount < $5) {
						$line = $_; $stop = $3; $miRNAcount = $mirseq{$4}; $degcount = $5;
					}
				#elsif ($mirseq{$4} == $miRNAcount) {
					elsif ($degcount == $5) {
					#if ($5 > $degcount) {
						if ($mirseq{$4} > $miRNAcount) {
							$line = $_; $stop = $3; $miRNAcount = $mirseq{$4}; $degcount = $5;
						}
					}
				}
				elsif ($2 > $stop) {
					print $line;
					$line = $_; $stop = $3; $miRNAcount = $mirseq{$4}; $degcount = $5;
				}
			}
			else {
				print $line;
				$line = $_; $stop = $3; $miRNAcount = $mirseq{$4}; $degcount = $5; $chromosome = $1;
			}
		}
	}
}
print $line;
