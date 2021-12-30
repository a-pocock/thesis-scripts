#!/bin/perl

# take two fasta files, check for sequences contained in both files

my ($file1, $file2) = @ARGV;

open(IN1,$file1) or die "can't open $!";

my %dict;
while (<IN1>){
	my $name = $_;
	my $seq = <IN1>;
	$dict{$seq} = $name;
}

open (IN2, $file2) or die "can't open $!";
while (<IN2>){
	if (exists ($dict{$_})) {
		print "$dict{$_}$_";
	}
}
