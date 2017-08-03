#!/usr/bin/perl -w
use strict;

my $fa = shift;
my $mu = shift;
my $out = shift;

my %aa;
open IN, $fa or die $!;

$/=">"; <IN>; $/="\n";

while(<IN>){
    chomp;
    my $aa_id =(split)[0]; 
    $/ = "\>";
    my $seq = <IN>;
    $seq =~ s/\n//g;
    $seq =~ s/>$//g;

    $aa{$aa_id} = [(split//,$seq)];
    $/ = "\n";
}
close IN;

open MU, $mu or die $!;
while(<MU>){
    chomp;
    next if(/^$/);
    my @inf = split/\s+/;
    if($aa{$inf[0]}[$inf[1]-1] eq $inf[3]){
        $aa{$inf[0]}[$inf[1]-1] = $inf[2];	
    }elsif($aa{$inf[0]}[$inf[1]-1] eq $inf[2]){
	print "OK\n";
    }else{
        print STDERR "Wrong...$_\n";
    }
}

open OUT, ">$out" or die $!;
foreach my $key (sort keys %aa){
    my $line = join"",@{$aa{$key}};
    print OUT ">$key\n$line\n";
}
