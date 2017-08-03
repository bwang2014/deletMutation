#!/usr/bin/perl -w
use strict;

my $ancestral = shift;
my $ref = shift;
my $out = shift;

my %ances_state;
open IN, $ancestral or die $!;
while(<IN>){
    chomp;
    my @inf1 = split/\t/;
    my $len = length($inf1[2]);
#    print $len."\n";
    if($len == 1){
	$ances_state{"$inf1[0]-$inf1[1]"} = $inf1[2];
    }
}
close IN;
#__END__
open REF, $ref or die $!;
open OUT, ">$out" or die $!;
while(<REF>){
    chomp;
    my ($nt, $aa) = ("","");
    my @inf2 = split/\t/;
    if(exists $ances_state{"$inf2[0]-$inf2[1]"}){
	if($ances_state{"$inf2[0]-$inf2[1]"} eq $inf2[2]){
	    $nt = $inf2[6];
	    $aa = $inf2[7];
	    print OUT $_."\t$inf2[2]\t$nt\t$aa\tances_ref\n";
	}elsif($ances_state{"$inf2[0]-$inf2[1]"} eq $inf2[3]){
	    $nt = &swap_mutation_pos($inf2[6]);
	    $aa = &swap_mutation_pos($inf2[7]);
	    print OUT "$_\t$inf2[3]\t$nt\t$aa\tances_alt\n";
	}else{
	    print OUT "$_\t$ances_state{\"$inf2[0]-$inf2[1]\"}\ttwo_derived_alleles\n";
	}
    }else{
	print OUT "$_\tno_ancestral_alleles\n";
    }
}

sub swap_mutation_pos{
    my $aa = $_[0];
    my @inf = split//, $aa;
    my $top = shift @inf;
    my $end = pop @inf;
    #
    push @inf, $top;
    unshift @inf, $end;
    return (join("", @inf));
}

