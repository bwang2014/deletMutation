#!/usr/bin/perl -w
use strict;

die "Usage: perl $0 <chr_accessions> <file_to_rename> <file_renemed>\n" unless(@ARGV == 3);

my $db = shift;
my $in = shift;
my $out = shift;

my %name;
open DB, $db or die $!;
while(<DB>){
    chomp;
    next if(/^$/);
    my @inf = split/\t/;
    $name{"$inf[0]-$inf[1]"} = $_;
}
close DB;

open IN, $in or die $!;
open OUT, ">$out" or die $!;
while(<IN>){
    chomp;
    next if(/^\s+$/);
    if(/^#/){
	print OUT $_;
    }else{
	my @inf2 = split/\t/;
	if(exists $name{"$inf2[0]-$inf2[1]"}){
#	    $inf2[0] = $name{$inf2[0]};
#	    my $line = join"\t", @inf2;
	    print OUT "$_\n";
	}
    }
}
close IN;
close OUT;

