#!/bin/perl
use strict;
use warnings;
# read through provided fa file of annotations and predicted sRNA
# output annotated and unannotated miRNA in fa format.

my ($annotations, $sRNA, $annot_out, $unannot_out)= @ARGV;
my %annot;
open (ANNOT, $annotations) or die "can't open $!";
while (<ANNOT>) {
	#	if ($_ =~ />(tae-miR\d+)/ ) {
	if ($_ =~ /(\d+)/) {
		my $name = $1;
		my $seq = (<ANNOT>);
		chomp $seq;
		exists ($annot{$seq}{$1}{$1});
	}
}
open (ANNOUT,">>$annot_out") or die "can't open $!";
open (UNANNOUT, ">>$unannot_out") or die "can't open $!";
open (IN, $sRNA) or die "can't open $!";
while (<IN>) {
	if ($_ =~ /(>\w+)/) {
		my $seq = (<IN>);
		chomp $seq;
		if (exists($annot{$seq})) {
			foreach my $key (keys %{$annot{$seq}}) {
				print ANNOUT ">$key\n$seq\n";
			}
		}
		else {
			print UNANNOUT ">$seq\n$seq\n";
		}
	}
}
