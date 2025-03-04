#!/usr/bin/perl -w
use strict;

# covert Delly output files to vcf

my $var_file = shift @ARGV;

my $min_sv_len = 30;

my %vcf;

open (FILE, $var_file) or die "$var_file is not found: $!\n";
while (my $line = <FILE>){
    chomp $line;
    if ($line =~ /^#/){
	print $line, "\n";
	next;
    }	
    my @line = split (/\t/, $line);
    my $chr = $line[0];
    my $pos = $line[1];
    my $type = $1 if ($line[7] =~ /SVTYPE=(.+?);/);
    my $len = 0;
    $len = $1 if ($line[7] =~ /SVLEN=-*(\d+);/);
    next if ($len < $min_sv_len) and ($len > 0);
    my $end = $pos + $len - 1;
    my $qual = $line[6];
    my $reads = 7;
    next if ($qual ne 'PASS');
    my $chr_02d = $chr;
    $chr_02d = sprintf ("%02d", $chr) if ($chr =~ /^\d+$/);
    next if ($chr !~ /^\d+$|[XY]/);
    my $gt = './.';
    $gt = $1 if ($line[-1] =~ /([^:]+)/);
    print "$chr\t$pos\t$type\t.\t.\t.\t$qual\tSVTYPE=$type;SVLEN=$len;READS=$reads;GT=$gt\n";
}
close (FILE);
