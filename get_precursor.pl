#!/bin/perl
use strict;
use warnings;

my ($input) = @ARGV;
open (IN, $input) or die "can't open $!";
my $header;
my %sequence;
while (<IN>) {
	if ($_ =~ />/) {
		$header = $_;
	}
	elsif ($_ =~ /(\w+)/) {
		if (exists ($sequence{$header})) {
			$sequence{$header} = $sequence{$header}.$1;
		}
		else {
			$sequence{$header} = $1;
		}
	}
}
my %names = ('tae' => 1, 'osa' => 1, 'zma' => 1, 'ata' => 1, 'ath' => 1, 'gma' => 1);

foreach my $name (keys %sequence) {
	if ($sequence{$name} =~ /UCGGACCAGGCUUCAUUCCCC/) {
		if ($name =~ />(\w+)/) { 
			if ( exists ($names{$1})) {
				print "$name$sequence{$name}\n";
			}
		}
	}
}
