#!/bin/perl

use strict;
use warnings;
use File::Temp qw(tempfile);
#this script will get sRNA sequence names and sequences, create a fa file of seq matching the deg
#make db file, run alignment of the two, check cleavage in right location
#delete unwanted alignments and return sRNA for further investigation
#
my ($patman_deg, $transcript_match, $sRNA, $output) = @ARGV;


open (NAMES, $patman_deg) or die "can't open $!";
my %names;
while (<NAMES>) {
	$_ =~ /(\S+)\t(\S+)/;
	exists ($names{$2}{$1}{$1});
}
close NAMES;

open (SRNA, $sRNA) or die "can't open $!";
my %sRNA_hash;
while (<SRNA>) {
	$_ =~ /^>(\S+)/;
	if (exists ($names{$1})) {
		my $sseq = <SRNA>;
		chomp $sseq;
		foreach my $key (keys %{$names{$1}}) {
			$sRNA_hash{$key}{$1} = $sseq;
		}	
	}
}

close SRNA;

open (TRANS, $transcript_match) or die "Can't open $!";
open (OUT, ">>$output") or die "Can't open $!";
#my %reported; #add a list of sRNA which have already been reported.
my $line = <TRANS>;
while (<TRANS>) {
#	if ($line =~ /^>(\d+-\d+)-(\d+)/) {    original line
	if ($line =~ /^>(\d+-\d+)/) {
		if (exists ($sRNA_hash{$1})) {
#make temp sRNA database
			my $TEMPSRNA = File::Temp->new();
#			open (TEMPSRNA, ">>$TEMPSRNA") or die "Can't open $!";
			foreach my $key (keys %{$sRNA_hash{$1}}) {
#				if ( exists ($reported{$key}) ) {
#				}
#				else {
#				print $TEMPSRNA ">$key-$2\n$sRNA_hash{$1}{$key}\n";     original line
					print $TEMPSRNA ">$key\n$sRNA_hash{$1}{$key}\n";
#				}
			}
#make temp transcript db
			my $tempdb = File::Temp->new();
#			open (TEMPDB, ">>$tempdb") or die "Can't open $!";
			print $tempdb "$line","$_";
			while (<TRANS>) {
				if ($_ !~ /^>/) {
					print $tempdb $_;
				}
				else {
					$line = $_;
					my $tempout = File::Temp->new();
					system ("/tools/bioinfo/app/uea-srna-toolkit-20130326/bin/patman -q -l 15 -e 4 -D $tempdb -P $TEMPSRNA -o $tempout");
#iterate through lines in tempout - if \S+\t\S+\t\d < match or < \t\d
#					open (TEMPOUT, "$tempout") or die "Can't open $!";
					seek $tempout, 0, 0 or die "Seek $tempout failed: $!\n";
					while (<$tempout>) {
#						$_ =~ /\d+-\d+-(\d+)\t\S+\t\S+\t(\d+)\t(\d+).*/;
#						if ($1 <= $2 && $1 >= $3 || $1 <= $3 && $1 >= $2) {
#						print OUT $_;
						$_ =~ /\S+\t(\S+)\t(\d+)\t(\d+).*/;
						if (20 <= $2 && 20 >= $3 || 20 <= $3 && 20 >= $2) {
							print OUT $_;
#							exists ($reported{$1}{$1}); #add to the number of output sRNA
						}
					}
#					close(TEMPDB);close(TEMPSRNA);close(TEMPOUT);
#					system ("rm temp*");
					last;
				}
			}
		}
		else {
		$line = $_;
		}
	}
	else {
	$line = $_;
	}
}

