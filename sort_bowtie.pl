#!/bin/perl
#
use strict;
use warnings;
# Takes bowtie alignments and sorts the output. Input is collated from multiple prediction strategies and are output in a summary table.
#
my ($input) = @ARGV;
open (IN, $input) or die "can't open $!";
my %groups; my $counter = 0; my $end = 0; my $len; my $chr;
while (<IN>) {
	$_ =~ /^(\S+)\t\S+\t(\S+)\t(\d+)(?:\t\S+){5}\t(\S+)/;
	#	$_ =~ /^([^_]+)\S+\t\S+\t(\S+)\t(\d+)(?:\t\S+){5}\t(\S+)/;
	my $newlen = length($4);
	my $newend = $3+$newlen;
	if ($chr = $2) {
		if ($end > $3) {
			my $overlap = $end-$3;
			if (($overlap >= ($newlen*0.8)) || ($overlap >= ($len*0.8))) {
				$groups{$counter}{$1} = $1;
			}
			else {
				$counter++;
				$groups{$counter}{$1} = $1;
			}
		}
		else {
			$counter++;
			$groups{$counter}{$1} = $1;
		}
	}
	else {
		$counter++;
		$groups{$counter}{$1} = $1;
	}
	$len = $newlen;
	$end = $newend;
	$chr = $2;	
}
my $count = 0;

OUTER: while ($count <= $counter) {
	my $newcount = 0;
	LABEL: while ($newcount <= $counter) {
		if ($count == $newcount) {
			$newcount ++;
		}
		if ( exists ($groups{$count})) {
			if ( exists ($groups{$newcount})) {
				print "count is $count newcount is $newcount\n";
				foreach my $seq (keys %{$groups{$count}}) {
					if ( exists ($groups{$newcount}{$seq})) {
					}
					else {
						$newcount ++;
						next LABEL;
					}
				}
				delete ($groups{$count});
			}
			else {
				$newcount ++;
			}
		}
		else {
			$count ++;
			next OUTER;
		}
	}
	$count ++;
}

my $finalcount=0;
foreach my $key (keys %groups) {
	$finalcount ++;
}
#print "the final number of sequences is $finalcount\n\n\n";
$count = 0;
my %seqlist;
print "mircat mireap miRDeep2 miRPlant shortstack miRanalyzer miRcurio mirbase";
while ($count <= $counter) {
	if ( exists ($groups{$count})) {
		@{$seqlist{$count}} = (0,0,0,0,0,0,0,0);
		foreach my $key (keys %{$groups{$count}}) {
			#			print "$key\n";
			$key =~ /([^_]+)/;
			if ($1 eq "mircat") { $seqlist{$count}[0] = 1}
			if ($1 eq "mireap") { $seqlist{$count}[1] = 1}
			if ($1 eq "miRDeep2") { $seqlist{$count}[2] = 1}
			if ($1 eq "miRPlant") { $seqlist{$count}[3] = 1}
			if ($1 eq "shortstack") { $seqlist{$count}[4] = 1}
			if ($1 eq "miRanalyzer") { $seqlist{$count}[5] = 1}
			if ($1 eq "miRcurio") { $seqlist{$count}[6] = 1}
			if ($1 eq "mirbase") { $seqlist{$count}[7] = 1}
			push (@{$seqlist{$count}}, $key);
			
		}
		print "\n@{$seqlist{$count}}";
	}
	$count ++;
}
