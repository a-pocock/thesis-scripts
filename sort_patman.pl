#!/bin/perl
#
use strict;
use warnings;
# take sorted patman file as input. Identify regions with greater than 
# 80% overlap. Link these together. 
# collapse regions and output file with each predictor which had a precursor in this region
#
my ($input) = @ARGV;
open (IN, $input) or die "can't open $!";
my %groups; my $counter = 0; my $end = 0; my $len; my $chr;
while (<IN>) {
	$_ =~ /^(\S+)\t(\S+)\t(\d+)\t(\d+)\t.\t(\S+)/;
	my $newlen = $4-$3;
	my $newend = $4;
	if ($chr = $1) {
		if ($end > $3) {
			my $overlap = $end-$3;
			if (($overlap >= ($newlen*0.8)) || ($overlap >= ($len*0.8))) {
				$groups{$counter}{$2} = $2;
			}
			else {
				$counter++;
				$groups{$counter}{$2} = $2;
			}
		}
		else {
			$counter++;
			$groups{$counter}{$2} = $2;
		}
	}
	else {
		$counter++;
		$groups{$counter}{$2} = $2;
	}
	$len = $newlen;
	$end = $newend;
	$chr = $1;	
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
				#				print "count is $count newcount is $newcount\n";
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
print "miRcurio miRDeep2 miRPlant shortstack sRNAtoolbox wheat monocot PNRD";
while ($count <= $counter) {
	if ( exists ($groups{$count})) {
		@{$seqlist{$count}} = (0,0,0,0,0,0,0,0);
		foreach my $key (keys %{$groups{$count}}) {
			#			print "$key\n";
			$key =~ /([^_]+)/;
			if ($1 eq "miRcurio") { $seqlist{$count}[0] = 1}
			if ($1 eq "miRDeep2") { $seqlist{$count}[1] = 1}
			if ($1 eq "miRPlant") { $seqlist{$count}[2] = 1}
			if ($1 eq "shortstack") { $seqlist{$count}[3] = 1}
			if ($1 eq "sRNAtoolbox") { $seqlist{$count}[4] = 1}
			if ($1 eq "wheat") { $seqlist{$count}[5] = 1}
			if ($1 eq "monocot") { $seqlist{$count}[6] = 1}
			if ($1 eq "PNRD") { $seqlist{$count}[7] = 1}
			push (@{$seqlist{$count}}, $key);
			
		}
		print "\n@{$seqlist{$count}}";
	}
	$count ++;
}

#my $newcounter = 1;
#while ($newcounter <= $counter) {
#	my @keylist;
#	foreach my $key (%{$groups{$newcounter}}) {
#		push(@keylist, $key);
#	}
#	my $countpoint = 1;
#	my $listlen = scalar @keylist;
#	while ($countpoint <= $counter) {
#		my $matchcount = 0;
#		foreach ( @keylist ) {
#			if (exists ($groups{$countpoint}{$_})) { $matchcount++; }
#		}
#		if (($matchcount == $listlen) and ($countpoint != $newcounter)) {
			#remove entry as already exists and return to start
			#			delete($groups{$newcounter});
			#			last;
			#		}
		#		$countpoint++;
		#	}
	#	$newcounter++;
	#}

#foreach my $key (keys %groups) {
	#	print "$key\t";
	#	foreach my $name (keys %{$groups{$key}}) {
	#		#		print "$name\t";
	#	}
	#	print "\n";
	#}

#print "\n\n\n\n$counter\n\n\n\n"

#perl -lane 'if ($_ =~ /AS:i[^\d]+(\d+)\tXS:i[^\d]+(\d+)/) { if (($1 < $2) or ($2 == 0)) { print $_}} else {print $_}' miRBase_bowtie2 > test2

