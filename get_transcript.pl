#!/bin/perl
#
# Take list of gene names and the IWGSC file of high confidence genes. Output all genes from the list in fasta format
#
my ($gene_names, $genes) = @ARGV;
open (IN, $gene_names) or die "can't open $!";
my %ids = {};
while (<IN>) {
	if ($_ =~ /(\w+)/) {
		$ids{$1} = 1;
	}
}
my $val = "false";
open (GENE, $genes) or die "can't open $!";
while (<GENE>) {
	if ($_ =~ />(\w+)\./) {
		if (exists ($ids{$1})) {
			print $_;
			$val = "true";
		}
		else {
			$val = "false";
		}
	}
	elsif ($val eq "true") {
		print $_;
	}
	else {
		$val = "false";
	}
}
