#!/usr/bin/perl -w
use strict;

while(<>){
    chomp;
    my @inf = split;
    my @mu = split//, $inf[1];
    my $ancestral = shift @mu;
    my $derived = pop @mu;
    my $pos = join"",  @mu;
    print "$inf[0]\t$pos\t$ancestral\t$derived\n";
}
