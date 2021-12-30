#!/bin/perl
use strict;
use warnings;

# script to take a list of gene identifiers and extract the protein sequences for their respective proteins.
# Input is a list of identifiers and a protein database in .fa format.
#
my ($list, $database) = @ARGV;
open (IN, $list) or die "can't open $!";
my %identifiers;
while (<IN>) {
	$_ =~ /(\S+)/;
	exists($identifiers{$1}{$1});
}
my $value = "false";
open (DB, $database) or die "can't open $!";
while (<DB>) {
	if ($_ =~ /gene=(\S+)/) {
		if ( exists($identifiers{$1})) {
			print $_;
			$value = "true";
		}
		else {
			$value = "false";
		}
	}
	elsif ($value eq "true") {
		print $_;
	}
}
