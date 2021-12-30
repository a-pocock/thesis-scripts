#!/bin/perl
#read through fastq file and remove sequences shorter than 16nt

use strict;
use warnings;
#my $f = <STDIN>; #get filename
#my $out = $ARGV[1];
#print $f;
while (<>) {
	my $name = $_;
	my $seq = <>;
	chomp $seq;
	my $seqlen = length($seq);
	my $line3 = <>;
	my $line4 = <>;
	if ($seqlen <= 35 and $seqlen >=16) {
		print "$name","$seq","\n","$line3","$line4";
	}
}
#open my <STDIN>, "$f" or die "Can't open: $!";
#open (OUTFILE, ">>$out") or die "Can't open: $!";

#while (<$STDIN>) {
#        my $line1 = $_;
#	my $seq = <$STDIN>;
#        chomp $seq;
#        my $seqlen = length($seq);
#	my $line3 = <$STDIN>;
#	my $line4 = <$STDIN>;
#        if ($seqlen <= 35 and $seqlen >=17) {
#                        print "$line1","$seq","\n",$line3,$line4;
#        }
#}
